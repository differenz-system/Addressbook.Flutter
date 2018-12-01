import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:addressbook_flutter/src/model/AddressBook.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name addressbook.db in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "addressbook.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE AddressBook(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, contact_number TEXT, isactive INTEGER )");
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<AddressBook>> getAddressBooks() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM AddressBook');
    List<AddressBook> addressbooks = new List();
    for (int i = 0; i < list.length; i++) {
      addressbooks.add(new AddressBook(list[i]["id"], list[i]["name"],
          list[i]["email"], list[i]["contact_number"], list[i]["isactive"]));
    }
    print(addressbooks.length);
    return addressbooks;
  }

    /*
     * insert data into db
     */
  void saveAddressBook(AddressBook employee) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO AddressBook(name, email, contact_number, isactive ) VALUES(' +
              '\'' +
              employee.name +
              '\'' +
              ',' +
              '\'' +
              employee.email +
              '\'' +
              ',' +
              '\'' +
              employee.contact_number +
              '\'' +
              ',' +
              '\'' +
              employee.isactive.toString() +
              '\'' +
              ')');
    });
  }

    /*
     * update the data in db
     */
  void updateAddressBook(AddressBook employee, int _id) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE AddressBook SET name = ?, email = ?, contact_number = ?, isactive = ? WHERE id = ?',
          [
            employee.name,
            employee.email,
            employee.contact_number,
            employee.isactive.toString(),
            _id
          ]);
    });
  }

    /*
     * delete data in db
     */
  void deleteAddressBook(int _id) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawDelete('DELETE FROM AddressBook WHERE id = ?', [_id]);
    });
  }
}
