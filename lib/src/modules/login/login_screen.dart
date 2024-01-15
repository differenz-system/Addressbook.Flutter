import 'package:addressbook_flutter/src/customWidgets/my_button.dart';
import 'package:addressbook_flutter/src/modules/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:addressbook_flutter/src/utils/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: globals.bgColor,
        appBar: AppBar(
          backgroundColor: globals.barColor,
          centerTitle: true,
          title: const Text(globals.login),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50.0.w, 60.0.h, 50.0.w, 0.0.h),
            child: Form(
                key: controller.formKey,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextFormField(
                          controller: controller.emailController,
                          focusNode: controller.emailFocusNode,
                          onFieldSubmitted: (term) {
                            FocusScope.of(context)
                                .requestFocus(controller.passwordFocusNode);
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration:
                              const InputDecoration(labelText: globals.email),
                          validator: (val) => !globals.validateEmail(val!)
                              ? globals.invalid_email
                              : null,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 20.0.w, 0.0, 0.0),
                        ),
                        TextFormField(
                          focusNode: controller.passwordFocusNode,
                          controller: controller.passwordController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              labelText: globals.password),
                          validator: (val) => val!.length < 6
                              ? globals.min_length_password
                              : null,
                          obscureText: true,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 65.0.h, 0.0, 0.0),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            titleText: globals.log_in,
                            onPressed: () {
                              //This function will dismissed the keyboard when login button is pressed.
                              FocusScope.of(context).unfocus();
                              controller.submit();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
