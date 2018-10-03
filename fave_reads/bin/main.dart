import 'dart:io' show Platform;
import 'package:fave_reads/fave_reads.dart';

Future main() async {
  final app = Application<FaveReadsChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: Platform.numberOfProcessors);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}