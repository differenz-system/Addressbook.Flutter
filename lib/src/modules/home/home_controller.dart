import 'package:addressbook_flutter/src/database/db_helper.dart';
import 'package:addressbook_flutter/src/model/address_book.dart';
import 'package:addressbook_flutter/src/modules/login/login_screen.dart';
import 'package:addressbook_flutter/src/modules/update/update_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;

//Home controller is craeted for handling logic part of home screen
class HomeController extends GetxController {
  var dbHelper = DBHelper();
  var count = 0;
  List<AddressBook> allAddressBook = [];

  //This method will retrive all addressbook data from database and store it in allAddressbook variable
  void getData() {
    final dbFuture = dbHelper.initializeDb();
    dbFuture.then((result) {
      final addressBookFuture = dbHelper.getAddressBooks();
      addressBookFuture.then((result) {
        if (result != null) {
          List<AddressBook> bookList = [];
          count = result.length;
          for (int i = 0; i < count; i++) {
            bookList.add(AddressBook.fromObject(result[i]));
          }

          allAddressBook = bookList;
          count = count;
          update();
        }
      });
    });
  }

  //This method will navigate user to update screen and when the user will back to the screen data will refresh
  void navigateUpdateScreen(AddressBook? addressbooks) async {
    await Get.toNamed(UpdateScreen.routeName,
        arguments: {'addressbooks': addressbooks});
    getData();
  }

  void onTapItem(AddressBook addressbooks_item) {
    navigateUpdateScreen(addressbooks_item);
  }

  //This method will erase saved login data from local storage and navigate user back to login screen
  clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //remove data from shared preference
    prefs.setString(globals.user_map, "");
    Get.offNamed(LoginPage.routeName);
  }

  void logout() {
    clearUser();
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
