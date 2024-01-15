import 'package:addressbook_flutter/src/customWidgets/my_button.dart';
import 'package:addressbook_flutter/src/modules/update/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateScreen extends StatefulWidget {
  static const String routeName = "/updateScreen";
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateController>(
      builder: (controller) => Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: globals.bgColor,
        appBar: AppBar(
          backgroundColor: globals.barColor,
          title: const Text(globals.details),
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings_power),
                onPressed: controller.logout),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50.0.w, 30.0.h, 50.0.w, 0.0),
            child: Form(
                key: controller.formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: controller.addressbooksData != null
                          ? controller.addressbooksData!.name
                          : '',
                      textInputAction: TextInputAction.next,
                      focusNode: controller.nameFocusNode,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(controller.emailFocusNode);
                      },
                      decoration:
                          const InputDecoration(labelText: globals.name),
                      validator: (val) =>
                          val!.isEmpty ? globals.validation_name : null,
                      onSaved: (val) => controller.name = val,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0.0, 15.h, 0.0, 0.0)),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: controller.addressbooksData != null
                          ? controller.addressbooksData!.email
                          : '',
                      focusNode: controller.emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(controller.contactFocusNode);
                      },
                      decoration:
                          const InputDecoration(labelText: globals.email),
                      validator: (val) => (!globals.validateEmail(val!))
                          ? globals.invalid_email
                          : null,
                      onSaved: (val) => controller.email = val,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0.0, 15.h, 0.0, 0.0)),
                    TextFormField(
                      initialValue: controller.addressbooksData != null
                          ? controller.addressbooksData!.contact_number
                              .toString()
                          : '',
                      focusNode: controller.contactFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: globals.contact_no),
                      validator: (val) => val!.length != 10
                          ? globals.validation_enter_no
                          : null,
                      onSaved: (val) => controller.contactNumber = val,
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0.0, 15.h, 0.0, 0.0)),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Switch(
                            activeColor: globals.greenThemeColor,
                            value: controller.isChecked,
                            onChanged: controller.onChangedIsActive,
                          ),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0.0, 40.h, 0.0, 0.0)),
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                        titleText: controller.addressbooksData != null
                            ? globals.update
                            : globals.save,
                        onPressed: () {
                          controller.addressbooksData != null
                              ? controller.submitUpdate()
                              : controller.submit();
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0.0, 10.h, 0.0, 0.0)),
                    SizedBox(
                        width: double.infinity,
                        child: MyButton(
                          titleText: controller.addressbooksData != null
                              ? globals.delete
                              : globals.cancel,
                          onPressed: () {
                            controller.addressbooksData != null
                                ? controller.deleteScreen(context)
                                : controller.cancelScreen();
                          },
                        )),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
