import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Stay on one persistent storage backend across reloads and header changes.
/// Existing OPFS data needs an explicit migration, not a silent empty library.
QueryExecutor openLocalConnection() => DatabaseConnection.delayed(
  Future(() async {
    final probe = await WasmDatabase.probe(
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
      databaseName: 'trace_local_v1',
    );
    if (!probe.availableStorages.contains(
      WasmStorageImplementation.sharedIndexedDb,
    )) {
      throw StateError('Browser cannot provide reliable Trace storage.');
    }
    return probe.open(
      WasmStorageImplementation.sharedIndexedDb,
      'trace_local_v1',
    );
  }),
);
