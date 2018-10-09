import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

Future createDatabaseSchema(ManagedContext context, bool isTemporary) async {
  try {
    final builder = SchemaBuilder.toSchema(
        context.persistentStore, Schema.fromDataModel(context.dataModel),
        isTemporary: isTemporary);

    for (var cmd in builder.commands) {
      await context.persistentStore.execute(cmd);
    }
  } catch(e) {
    // Database may already exists
  }
}