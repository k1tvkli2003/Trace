import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:trace_domain/trace_domain.dart' as domain;

import 'trace_database.dart' as db;

/// Deterministic fixed-ladder review scheduler with an append-only event log.
/// AI never computes schedules; every projection rebuilds from stored events.
final class LocalReviewRepository {
  const LocalReviewRepository(this.database);

  final db.TraceDatabase database;

  static const List<int> fixedLadderDays = [1, 3, 7, 15, 30];
  static const String schedulerVersion = 'fixed-ladder-v1';
  static const String offsetSchedulerVersion = 'fixed-offset-v2';
  static const List<int> offsetGapsDays = [1, 2, 4, 8, 15];
  static const List<int> postOffsetGapsDays = [30, 60, 120];

  static int _nextOffsetGap(int current, int steps) {
    final gaps = [...offsetGapsDays, ...postOffsetGapsDays];
    final index = current == 0 ? -1 : gaps.indexOf(current);
    if (index < 0 && current != 0) {
      throw const FormatException('Invalid v2 review gap');
    }
    final next = index + steps;
    return gaps[next < gaps.length ? next : gaps.length - 1];
  }

  /// Creates first-study v2 projection: due A+1 day, gap 1, no lapses.
  /// Rejects non-UTC instants; local timezone remains display-only.
  static domain.ReviewItem firstStudyItem({
    required String id,
    required String targetId,
    required domain.ReviewTargetType targetType,
    required String contentHash,
    required DateTime firstStudiedAt,
    int version = 1,
    double ease = 2.5,
  }) {
    if (!firstStudiedAt.isUtc) {
      throw const FormatException('First study must be a UTC instant');
    }
    if (targetType == domain.ReviewTargetType.unsupported) {
      throw const FormatException('Unsupported review target is rejected');
    }
    if (ease.isNaN || !ease.isFinite || ease < 1) {
      throw const FormatException('Ease must be finite and at least 1');
    }
    if (version < 1) {
      throw const FormatException('Version must be a positive integer');
    }
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(contentHash)) {
      throw const FormatException('contentHash must be lowercase SHA-256 hex');
    }
    return domain.ReviewItem.fromJson({
      'id': id,
      'version': version,
      'contentHash': contentHash,
      'targetType': targetType.wireName,
      'targetId': targetId,
      'dueAt': _utcPlusDays(firstStudiedAt, 1),
      'intervalDays': 1,
      'ease': ease,
      'lapses': 0,
      'state': domain.ReviewItemState.active.wireName,
      'schedulerVersion': offsetSchedulerVersion,
    });
  }

  /// Pure projection: good advances one rung, easy two rungs, hard holds,
  /// again resets to one day and counts a lapse. Unknown ratings fail closed.
  static domain.ReviewItem projectNext({
    required domain.ReviewItem current,
    required domain.ReviewRating rating,
    required DateTime occurredAt,
  }) {
    if (current.schedulerVersion == offsetSchedulerVersion) {
      return _projectNextOffset(
        current: current,
        rating: rating,
        occurredAt: occurredAt,
      );
    }
    if (current.schedulerVersion != schedulerVersion) {
      throw const FormatException('Scheduler version mismatch');
    }
    final base = current.toJson();
    switch (rating) {
      case domain.ReviewRating.again:
        return domain.ReviewItem.fromJson({
          ...base,
          'intervalDays': 1,
          'lapses': current.lapses + 1,
          'dueAt': _utcPlusDays(occurredAt, 1),
        });
      case domain.ReviewRating.hard:
        final interval = current.intervalDays == 0
            ? fixedLadderDays.first
            : current.intervalDays;
        return domain.ReviewItem.fromJson({
          ...base,
          'intervalDays': interval,
          'dueAt': _utcPlusDays(occurredAt, interval),
        });
      case domain.ReviewRating.good:
        final next = _advance(current.intervalDays, 1);
        return domain.ReviewItem.fromJson({
          ...base,
          'intervalDays': next,
          'dueAt': _utcPlusDays(occurredAt, next),
        });
      case domain.ReviewRating.easy:
        final next = _advance(current.intervalDays, 2);
        return domain.ReviewItem.fromJson({
          ...base,
          'intervalDays': next,
          'dueAt': _utcPlusDays(occurredAt, next),
        });
      case domain.ReviewRating.unsupported:
        throw FormatException('Unsupported rating cannot drive the scheduler');
    }
  }

  static domain.ReviewItem _projectNextOffset({
    required domain.ReviewItem current,
    required domain.ReviewRating rating,
    required DateTime occurredAt,
  }) {
    if (!occurredAt.isUtc) {
      throw const FormatException('Review instant must be UTC');
    }
    if (current.intervalDays != 0 && !_validOffsetGap(current.intervalDays)) {
      throw const FormatException('Invalid v2 review gap');
    }
    final int gap;
    final int lapses;
    switch (rating) {
      case domain.ReviewRating.again:
        gap = 1;
        lapses = current.lapses + 1;
      case domain.ReviewRating.hard:
        gap = current.intervalDays == 0 ? 1 : current.intervalDays;
        lapses = current.lapses;
      case domain.ReviewRating.good:
        gap = _nextOffsetGap(current.intervalDays, 1);
        lapses = current.lapses;
      case domain.ReviewRating.easy:
        gap = _nextOffsetGap(current.intervalDays, 2);
        lapses = current.lapses;
      case domain.ReviewRating.unsupported:
        throw const FormatException(
          'Unsupported rating cannot drive scheduler',
        );
    }
    return domain.ReviewItem.fromJson({
      ...current.toJson(),
      'intervalDays': gap,
      'lapses': lapses,
      'dueAt': _utcPlusDays(occurredAt, gap),
    });
  }

  static bool _validOffsetGap(int gap) =>
      offsetGapsDays.contains(gap) ||
      postOffsetGapsDays.contains(gap) ||
      gap == 0;

  static int _advance(int current, int steps) {
    var index = fixedLadderDays.indexOf(current);
    if (index < 0) index = -1;
    final next = index + steps;
    return fixedLadderDays[next >= fixedLadderDays.length
        ? fixedLadderDays.length - 1
        : next];
  }

  static String _utcPlusDays(DateTime value, int days) {
    final target = value.toUtc().add(Duration(days: days));
    final text = target.toIso8601String();
    if (!text.contains('.')) return text;
    final source = value.toUtc();
    if (source.millisecond == 0 && source.microsecond == 0) {
      return '${text.substring(0, text.indexOf('.'))}Z';
    }
    return text;
  }

  Future<void> putReviewItem(domain.ReviewItem item) async {
    _requireSupportedItem(item);
    await database.transaction(() async {
      final existing = await (database.select(
        database.reviewItems,
      )..where((row) => row.id.equals(item.id))).getSingleOrNull();
      if (existing != null) {
        final receipt = domain.ReviewItem.fromJson(
          jsonDecode(existing.initialPayloadJson) as Map<String, dynamic>,
        );
        if (!_sameJson(receipt.toJson(), item.toJson())) {
          throw StateError('Review item ${item.id} is immutable');
        }
        return;
      }
      await database
          .into(database.reviewItems)
          .insert(
            db.ReviewItemsCompanion.insert(
              id: item.id,
              version: Value(item.version),
              contentHash: item.contentHash,
              targetType: item.rawTargetType,
              targetId: item.targetId,
              dueAt: item.rawDueAt,
              intervalDays: item.intervalDays,
              ease: item.ease,
              lapses: Value(item.lapses),
              state: item.rawState,
              schedulerVersion: item.schedulerVersion,
              initialPayloadJson: jsonEncode(item.toJson()),
            ),
          );
    });
  }

  Future<domain.ReviewItem?> readReviewItem(String id) async {
    final row = await (database.select(
      database.reviewItems,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _itemFromRow(row);
  }

  /// Due means active and dueAt at or before [nowUtc]; ISO-8601 UTC, Z suffix.
  ///
  /// Timestamps are validated instants, not sortable strings: valid UTC input
  /// may include fractional seconds. Filter and order after parsing so a
  /// precision difference cannot hide a due item.
  Future<List<domain.ReviewItem>> listDueItems(String nowUtc) async {
    _utc(nowUtc, 'nowUtc');
    final now = DateTime.parse(nowUtc);
    final rows = await (database.select(
      database.reviewItems,
    )..where((row) => row.state.equals('active'))).get();
    final due =
        rows
            .map(_itemFromRow)
            .where((item) => !item.dueAt.isAfter(now))
            .toList()
          ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return due;
  }

  /// Appends one event and advances the item projection atomically. Replays
  /// of the same event id with identical payload are safe; forged next-due
  /// values, stale chains, and unknown ratings leave no partial write.
  Future<void> appendEvent(domain.ReviewEvent event) async {
    if (event.rating == domain.ReviewRating.unsupported) {
      throw FormatException('Unsupported rating cannot be appended');
    }
    if (event.schedulerVersion != schedulerVersion &&
        event.schedulerVersion != offsetSchedulerVersion) {
      throw FormatException('Scheduler version mismatch');
    }
    await database.transaction(() async {
      final duplicate = await (database.select(
        database.reviewEvents,
      )..where((row) => row.id.equals(event.id))).getSingleOrNull();
      if (duplicate != null) {
        if (!_sameJson(_eventFromRow(duplicate).toJson(), event.toJson())) {
          throw StateError('Review event ${event.id} is immutable');
        }
        return;
      }
      final itemRow = await (database.select(
        database.reviewItems,
      )..where((row) => row.id.equals(event.reviewItemId))).getSingleOrNull();
      if (itemRow == null) {
        throw StateError('Review item ${event.reviewItemId} is absent');
      }
      final current = _itemFromRow(itemRow);
      if (event.schedulerVersion != current.schedulerVersion) {
        throw const FormatException('Review event and item scheduler mismatch');
      }
      final historyRows = await (database.select(
        database.reviewEvents,
      )..where((row) => row.reviewItemId.equals(current.id))).get();
      if (historyRows.isNotEmpty) {
        final latest = historyRows
            .map(_eventFromRow)
            .reduce((a, b) => a.occurredAt.isAfter(b.occurredAt) ? a : b);
        if (!event.occurredAt.isAfter(latest.occurredAt)) {
          throw StateError(
            'Event time is not strictly newer for ${event.reviewItemId}',
          );
        }
      }
      if (current.state != domain.ReviewItemState.active) {
        throw StateError('Review item ${current.id} is not active');
      }
      if (event.occurredAt.isBefore(current.dueAt)) {
        throw StateError('Review item ${current.id} is not due');
      }
      if (event.rawPreviousDueAt != current.rawDueAt) {
        throw StateError('Event chain is stale for ${event.reviewItemId}');
      }
      final projected = projectNext(
        current: current,
        rating: event.rating,
        occurredAt: event.occurredAt,
      );
      if (event.rawNextDueAt != projected.rawDueAt) {
        throw StateError(
          'Event next due does not match deterministic projection',
        );
      }
      await database
          .into(database.reviewEvents)
          .insert(
            db.ReviewEventsCompanion.insert(
              id: event.id,
              version: Value(event.version),
              contentHash: event.contentHash,
              reviewItemId: event.reviewItemId,
              rating: event.rawRating,
              occurredAt: event.rawOccurredAt,
              previousDueAt: Value(event.rawPreviousDueAt),
              nextDueAt: event.rawNextDueAt,
              deviceId: event.deviceId,
              schedulerVersion: event.schedulerVersion,
            ),
          );
      await (database.update(
        database.reviewItems,
      )..where((row) => row.id.equals(current.id))).write(
        db.ReviewItemsCompanion(
          dueAt: Value(projected.rawDueAt),
          intervalDays: Value(projected.intervalDays),
          lapses: Value(projected.lapses),
        ),
      );
    });
  }

  Future<domain.ReviewEvent?> readEvent(String id) async {
    final row = await (database.select(
      database.reviewEvents,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _eventFromRow(row);
  }

  Future<List<domain.ReviewEvent>> listEvents(String reviewItemId) async {
    final rows = await (database.select(
      database.reviewEvents,
    )..where((row) => row.reviewItemId.equals(reviewItemId))).get();
    final events = rows.map(_eventFromRow).toList()
      ..sort((a, b) {
        final order = a.occurredAt.compareTo(b.occurredAt);
        return order != 0 ? order : a.id.compareTo(b.id);
      });
    return events;
  }

  static void _requireSupportedItem(domain.ReviewItem item) {
    if (item.targetType == domain.ReviewTargetType.unsupported ||
        item.state == domain.ReviewItemState.unsupported) {
      throw FormatException('Unsupported review target or state is rejected');
    }
    if (item.schedulerVersion != schedulerVersion &&
        item.schedulerVersion != offsetSchedulerVersion) {
      throw FormatException('Scheduler version mismatch');
    }
    if (item.schedulerVersion == offsetSchedulerVersion &&
        !_validOffsetGap(item.intervalDays)) {
      throw const FormatException('Invalid v2 review gap');
    }
  }

  domain.ReviewItem _itemFromRow(db.ReviewItem row) =>
      domain.ReviewItem.fromJson({
        'id': row.id,
        'version': row.version,
        'contentHash': row.contentHash,
        'targetType': row.targetType,
        'targetId': row.targetId,
        'dueAt': row.dueAt,
        'intervalDays': row.intervalDays,
        'ease': row.ease,
        'lapses': row.lapses,
        'state': row.state,
        'schedulerVersion': row.schedulerVersion,
      });

  domain.ReviewEvent _eventFromRow(db.ReviewEvent row) =>
      domain.ReviewEvent.fromJson({
        'id': row.id,
        'version': row.version,
        'contentHash': row.contentHash,
        'reviewItemId': row.reviewItemId,
        'rating': row.rating,
        'occurredAt': row.occurredAt,
        'previousDueAt': row.previousDueAt,
        'nextDueAt': row.nextDueAt,
        'deviceId': row.deviceId,
        'schedulerVersion': row.schedulerVersion,
      });

  static bool _sameJson(Map<String, Object?> a, Map<String, Object?> b) =>
      a.toString() == b.toString();

  static void _utc(String value, String field) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null || !parsed.isUtc || !value.endsWith('Z')) {
      throw FormatException('$field must be UTC with Z suffix');
    }
  }
}
