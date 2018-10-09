import 'dart:developer';

import 'package:fave_reads/controller/authors_controller.dart';
import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/controller/books_controller.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class FaveReadsChannel extends ApplicationChannel {

  ManagedContext context;
  Service service;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    final config = FaveReadsConfiguration(options.configurationFilePath);
    context = contextWithConnectionInfo(config.database);
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  ManagedContext contextWithConnectionInfo(DatabaseConfiguration connectionInfo) {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore(
        connectionInfo.username,
        connectionInfo.password,
        connectionInfo.host,
        connectionInfo.port,
        connectionInfo.databaseName);

    return ManagedContext(dataModel, psc);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router
      .route("/")
      .linkFunction((request) async {
        return Response.ok('Hello World!');
      });

    router
        .route("/books/[:id]")
        .link(() => BooksController(context)
        );

    router
        .route("/authors/[:id]")
        .link(() => AuthorsController(context)
    );

    return router;
  }

}

class FaveReadsConfiguration extends Configuration {
  FaveReadsConfiguration(String fileName) : super.fromFile(File(fileName));

  DatabaseConfiguration database;
}