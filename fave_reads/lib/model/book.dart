import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/model/author.dart';

class Book extends ManagedObject<_Book> implements _Book {}

class _Book {

  @primaryKey
  int id;

  String title;

  int year;

  ManagedSet<Author> authors;

}