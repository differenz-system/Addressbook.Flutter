import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:addressbook_flutter/src/login/Login.dart';
import 'package:addressbook_flutter/src/home/UpdateScreen.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:addressbook_flutter/src/database/DBHelper.dart';
import 'package:addressbook_flutter/src/model/AddressBook.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() =>  _HomePageState();
}
class _HomePageState extends State {
  var facebookLogin = FacebookLogin();
  var dbHelper = DBHelper();
  var count = 0;
  List<AddressBook> allAddressBook;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (allAddressBook == null) {
      allAddressBook = List<AddressBook>();
      getData();
    }
    return  Scaffold(
      appBar:  AppBar(
        title: Text(globals.app_name),
        centerTitle: true,
        backgroundColor: globals.barColor,
        actions: <Widget>[
           IconButton(
              icon:  Icon(Icons.settings_power), onPressed: _logout),
        ],
      ),
      body: createListView(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: globals.greenThemeColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              navigateUpdateScreen(null);
            });
          }),
    );
  }

  /*
     * this method is called when user click on item in the list.
     * Parameters context = pass the context of screen
     * Paremeters addressbooks_item = the item row data passed in intent
   */
  void _onTapItem(BuildContext context, AddressBook addressbooks_item) {
    navigateUpdateScreen(addressbooks_item);
  }

  /*
     navigate to update screen
     Parameters addressbooks = passed the item row data.
  */
  void navigateUpdateScreen(AddressBook addressbooks) async{

     bool result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateScreen(addressbooks: addressbooks)),
    );
    if(result!=null){
   getData();
    }
  }

  // logout method
  void _logout() {
    setState(() {
      _clearUser();
    });
  }

  _clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  //remove data from shared preference
    if (prefs.getBool(globals.user_fb_logged_in)) {
      prefs.setBool(globals.user_fb_logged_in, false);
      await facebookLogin.logOut();
    }

    setState(() {
      prefs.setString(globals.user_map, "");

      Route route = MaterialPageRoute(builder: (context) => Login());
      Navigator.pushReplacement(context, route);
    });
  }
  //Generate address book List

  Widget createListView() {

    return  ListView.builder(
      itemCount: count,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onTapItem(context, this.allAddressBook[index]),
          child:  Column(
            children: <Widget>[
               Padding(
                  padding: const EdgeInsets.only(top: 10)),
               SizedBox(
                width: double.infinity,
                child:  Text(
                  this.allAddressBook[index].name,
                  textAlign: TextAlign.start,
                  style:  TextStyle(color: Colors.black),
                ),
              ),
               Padding(
                  padding: const EdgeInsets.only(bottom: 5)),
               SizedBox(
                width: double.infinity,
                child:  Text(
                  this.allAddressBook[index].email,
                  textAlign: TextAlign.start,
                  style:  TextStyle(color: Colors.black),
                ),
              ),
               Padding(
                  padding: const EdgeInsets.only(bottom: 5)),
               SizedBox(
                width: double.infinity,
                child:  Text(
                  this.allAddressBook[index].contact_number,
                  textAlign: TextAlign.start,
                  style:  TextStyle(color: Colors.black),
                ),
              ),
               Padding(
                  padding: const EdgeInsets.only(bottom: 5)),
              Divider(height: 5.0),
            ],

          ),
        );
      },
    );
  }
  //retrieve data from database
  void getData() {
    final dbFuture = dbHelper.initializeDb();
    dbFuture.then((result) {
      final addressBookFuture = dbHelper.getAddressBooks();
      addressBookFuture.then((result) {
        List<AddressBook> bookList = List<AddressBook>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          bookList.add(AddressBook.fromObject(result[i]));
        }
        setState(() {
          allAddressBook = bookList;
          count = count;
        });
      });
    });
  }

}
