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
  _HomePageState createState() => new _HomePageState();
}

Future<List<AddressBook>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<AddressBook>> employees = dbHelper.getAddressBooks();
  return employees;
}

class _HomePageState extends State<HomeScreen> {
  var facebookLogin = FacebookLogin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: fetchEmployeesFromDatabase(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // list design layout
        return createListView(context, snapshot);
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: Text(globals.app_name),
        centerTitle: true,
        backgroundColor: globals.barColor,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings_power), onPressed: _logout),
        ],
      ),
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
      body: futureBuilder,
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
     * navigate to update screen
     * Parameters addressbooks = passed the item row data.
     */
  void navigateUpdateScreen(AddressBook addressbooks) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateScreen(addressbooks: addressbooks)),
    );
  }

  /*
     * logout method
     */
  void _logout() {
    setState(() {
      _clearUser();
    });
  }

  /*
     * async call for logout from facebook and app
     */
  _clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

  /*
     * widget to design listview layout
     * Parameters context = passed the context of screen
     * Parameters snapshot = passed the builder snapshot
     */
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<AddressBook> values = snapshot.data;
    return new ListView.builder(
      itemCount: values != null ? values.length : 0,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => _onTapItem(context, values[index]),
          child: new Column(
            children: <Widget>[
              Divider(height: 5.0),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              new SizedBox(
                width: double.infinity,
                child: new Text(
                  '${values[index].name}',
                  textAlign: TextAlign.start,
                  style: new TextStyle(color: Colors.black),
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0)),
              new SizedBox(
                width: double.infinity,
                child: new Text(
                  '${values[index].email}',
                  textAlign: TextAlign.start,
                  style: new TextStyle(color: Colors.black),
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0)),
              new SizedBox(
                width: double.infinity,
                child: new Text(
                  '${values[index].contact_number}',
                  textAlign: TextAlign.start,
                  style: new TextStyle(color: Colors.black),
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0)),
            ],
          ),
        );
      },
    );
  }
}
