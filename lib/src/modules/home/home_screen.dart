import 'package:addressbook_flutter/src/modules/home/home_controller.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text(globals.app_name),
          centerTitle: true,
          backgroundColor: globals.barColor,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings_power),
                onPressed: controller.logout),
          ],
        ),
        //This condition will display "No Data found text" if no data is found from database and render list of entries if data found
        body: controller.allAddressBook.isEmpty
            ? const Center(
                child: Text("No Data found!"),
              )
            : ListView.builder(
                itemCount: controller.allAddressBook.length,
                padding: EdgeInsets.all(10.0.h),
                itemBuilder: (BuildContext context, int index) {
                  var addressBookData = controller.allAddressBook[index];
                  return GestureDetector(
                    onTap: () => controller.onTapItem(addressBookData),
                    child: Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 10.h)),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            addressBookData.name,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5.h)),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            addressBookData.email,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5.h)),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            addressBookData.contact_number!,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5.h)),
                        Divider(height: 5.h),
                      ],
                    ),
                  );
                },
              ),
        // Add button is used to adding new contact data in database
        floatingActionButton: FloatingActionButton(
            backgroundColor: globals.greenThemeColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              controller.navigateUpdateScreen(null);
            }),
      ),
    );
  }
}
