import 'package:aqueduct/aqueduct.dart';

import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/model/author.dart';
import 'package:fave_reads/model/book.dart';

class BooksController extends ResourceController {

  final ManagedContext context;

  BooksController(this.context);

  // GET /books/
  @Operation.get()
  Future<Response> getBooks() async {
    print("Entrou books");
    final query = Query<Book>(context)..join(set: (book) => book.authors);
    return Response.ok(await query.fetch());
  }

  // GET /books/[:id]
  @Operation.get("id")
  Future<Response> getBook(@Bind.path("id") int id) async {
    final query = Query<Book>(context)
      ..join(set: (book) => book.authors)
      ..where((book) => book.id).equalTo(id);

    final book = await query.fetchOne();

    if (book == null) {
      return Response.notFound(body: 'Book does not exists');
    }
    return Response.ok(book);
  }

  // POST /book
  @Operation.post()
  Future<Response> addBook(@Bind.body() Book book) async {
    final query = Query<Book>(context)..values = book;
    final insertedBook = await query.insert();

    // Insert authors from payload
    await Future.forEach(book.authors, (Author a) async {
      final author = Query<Author>(context)
        ..values = a
        ..values.book = insertedBook; // set foreign key to inserted book
      return author.insert;
    });

    final insertedBookQuery = Query<Book>(context)
      ..where((book) => book.id).equalTo(insertedBook.id)
      ..join(set: (book) => book.authors);

    return Response.ok(await insertedBookQuery.fetchOne());
  }

  // POST /book/[:id]
  @Operation.post("id")
  Future<Response> updateBook(
      @Bind.path("id") int idx, @Bind.body() Book book) async {
    final query = Query<Book>(context)
      ..values = book
      ..where((book) => book.id).equalTo(idx);
    final updatedBook = await query.updateOne();

    if (updatedBook == null) {
      return Response.notFound(body: 'Book does not exists');
    }

    // Remove previous author from db
    final deletePreviousAuthorsQuery = Query<Author>(context)
      ..canModifyAllInstances = true
      ..where((book) => book.id).equalTo(updatedBook.id);

    await deletePreviousAuthorsQuery.delete();

    // Set New Authors from payload
    await Future.forEach(book.authors, (Author a) async {
      final author = Query<Author>(context)
        ..values = a
        ..values.book = updatedBook;
      return await author.insert();
    });

    // Build and execute query for updated book
    final updatedBookQuery = Query<Book>(context)
      ..where((book) => book.id).equalTo(updatedBook.id)
      ..join(set: (book) => book.authors);

    return Response.ok(await updatedBookQuery.fetchOne());
  }

  @Operation.delete("id")
  Future<Response> deleteBook(@Bind.path("id") int id) async {
    final query = Query<Book>(context)..where((book) => book.id).equalTo(id);

    final deletedBookId = await query.delete();

    if (deletedBookId == 0) {
      return Response.notFound(body: 'Book does not exist');
    }
    return Response.ok('Successfully deleted book');
  }

}