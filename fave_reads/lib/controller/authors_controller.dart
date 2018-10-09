import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:fave_reads/model/author.dart';

class AuthorsController extends ResourceController {

  final ManagedContext context;

  AuthorsController(this.context);

  @Operation.get("id")
  Future<Response> getAuthors(@Bind.path("id") int id) async {
    print("Entrou Authors - (id da request): $id");

    final query = Query<Author>(context)
      ..where((author) => author.id).equalTo(id);
    return Response.ok(await query.fetch());
  }

}