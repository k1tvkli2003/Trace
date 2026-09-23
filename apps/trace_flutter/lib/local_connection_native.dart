import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor openLocalConnection() => driftDatabase(name: 'trace_local_v1');
