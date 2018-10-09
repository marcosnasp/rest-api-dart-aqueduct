import 'package:fave_reads/fave_reads.dart';
import 'package:fave_reads/model/book.dart';
class Author extends ManagedObject<_Author> implements _Author { }

class _Author {

  @primaryKey
  int id;

  @Column(databaseType: ManagedPropertyType.string)
  String name;

  @Relate(#authors, onDelete: DeleteRule.nullify)
  Book book;

}