import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:addressbook_flutter/src/model/address_book.dart';

//DB helper class is created as a helper class for sqflite for performing crud operations in database
class DBHelper {
  static final DBHelper _dbHelper = DBHelper._internal();
  String tblAddressBook = "AddressBook";
  String colId = "id";
  String colName = "name";
  String colEmail = "email";
  String colContactUs = "contact_number";
  String colIsActive = "isactive";

  DBHelper._internal();

  factory DBHelper() {
    return _dbHelper;
  }

  static Database? _db;

  Future<Database?> get db async {
    _db ??= await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}addressbook.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    String sql =
        "CREATE TABLE $tblAddressBook($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, " +
            "$colEmail TEXT,$colContactUs TEXT, $colIsActive INTEGER)";
    await db.execute(sql);
  }

  //created for insering data in addressbook table
  Future<int?> insertAddressBook(AddressBook addressBook) async {
    Database? db = await (this.db);
    var result = await db?.insert(tblAddressBook, addressBook.toMap());
    return result;
  }

  //created for getting all saved data from addressbook table
  Future<List?> getAddressBooks() async {
    Database? db = await (this.db);
    var result = await db
        ?.rawQuery("SELECT * from $tblAddressBook order by $colId DESC");
    return result;
  }

  //created for getting count of total entries saved in addressbook table
  Future<int?> getCount(AddressBook addressBook) async {
    Database? db = await (this.db);
    if (db != null) {
      var result = Sqflite.firstIntValue(
          await db.rawQuery("SELECT COUNT(*) FROM $tblAddressBook"));
      return result;
    }
    return null;
  }

  //craeted for updating one entry in the addressbook table
  Future<void> updateAddressBook(AddressBook addressBook, int? id) async {
    Database? db = await (this.db);
    await db?.rawQuery(
        "UPDATE $tblAddressBook SET $colName=?, $colEmail =?, $colContactUs = ?,$colIsActive = ? WHERE $colId=$id",
        [
          addressBook.name,
          addressBook.email,
          addressBook.contact_number,
          addressBook.isactive
        ]);
  }

  //created for deleting one entry in the addressbook table
  Future<int?> deleteAddressBook(int? id) async {
    Database? db = await (this.db);
    int? result;
    result =
        await db?.rawDelete("DELETE FROM $tblAddressBook WHERE $colId = $id");
    return result;
  }
}
