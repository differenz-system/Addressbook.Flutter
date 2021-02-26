import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:addressbook_flutter/src/model/AddressBook.dart';
class DBHelper {
  static final DBHelper _dbHelper = DBHelper._internal();
  String tblAddressBook = "AddressBook";
  String colId = "id";
  String colName = "name";
  String colEmail = "email";
  String colContactUs = "contact_number";
  String colIsActive = "isactive";

  DBHelper._internal();

  factory DBHelper(){
    return _dbHelper;
  }


  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "addressbook.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    String sql = "CREATE TABLE $tblAddressBook($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, " +
        "$colEmail TEXT,$colContactUs TEXT, $colIsActive INTEGER)";
    await db.execute(sql);
  }

  Future<int> insertAddressBook(AddressBook addressBook) async {
    Database db = await this.db;
    var result = await db.insert(tblAddressBook, addressBook.toMap());
    return result;
  }

  Future<List> getAddressBooks() async {
    Database db = await this.db;
    var result = await db.rawQuery(
        "SELECT * from $tblAddressBook order by $colId DESC");
    return result;
  }

  Future<int> getCount(AddressBook addressBook) async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tblAddressBook")
    );

    return result;
  }

  Future<int> updateAddressBook(AddressBook addressBook, int id) async {
    Database db = await this.db;
    var result = await db.update(
        tblAddressBook, addressBook.toMap(), where: "$colId = $id", whereArgs: [addressBook.id]);
    return result;
  }

  Future<int> deleteAddressBook(int id) async {
    Database db = await this.db;
    int result;
    result = await db.rawDelete("DELETE FROM $tblAddressBook WHERE $colId = $id");
    return result;
  }

}
