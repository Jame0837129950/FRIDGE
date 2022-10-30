import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/states/create_account.dart';
import 'package:productexpire/states/main_home.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_dialog.dart';
import 'package:productexpire/widgets/widget_button.dart';
import 'package:productexpire/widgets/widget_form.dart';
import 'package:productexpire/widgets/widget_image.dart';
import 'package:productexpire/widgets/widget_text.dart';
import 'package:productexpire/widgets/widget_text_button.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: ListView(
          children: [
            head(),
            titleLogin(),
            formEmail(),
            formPassword(),
            buttonLogin(),
            createNewAccount(),
          ],
        ),
      ),
    );
  }

  WidgetTextButton createNewAccount() {
    return WidgetTextButton(
      label: 'Create New Account',
      pressFunc: () {
        Get.to(const CreateAccount());
      },
    );
  }

  Row buttonLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: 250,
          child: WidgetButton(
            label: 'Login',
            pressFunc: () {
              if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
                MyDialog(context: context).normalDialog(
                    title: 'Have Space ?', subTitle: 'Please Fill Every Blank');
              } else {
                processCheckLogin();
              }
            },
          ),
        ),
      ],
    );
  }

  Row formPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: 250,
          child: WidgetForm(
            obsecu: true,
            hint: 'Password :',
            iconData: Icons.lock,
            changeFunc: (p0) {
              password = p0.trim();
            },
          ),
        ),
      ],
    );
  }

  Row formEmail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: 250,
          child: WidgetForm(
            hint: 'Email :',
            iconData: Icons.mail,
            changeFunc: (p0) {
              email = p0.trim();
            },
          ),
        ),
      ],
    );
  }

  Container titleLogin() {
    return Container(
      margin: const EdgeInsets.only(left: 45, top: 30),
      child: Row(
        children: [
          WidgetText(
            text: 'Login :',
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }

  Container head() {
    return Container(
      margin: const EdgeInsets.only(top: 36, left: 36),
      child: Row(
        children: [
          const WidgetImage(
            size: 90,
          ),
          WidgetText(
            text: 'Product \nExpire',
            textStyle: MyConstant().h1Style(),
          )
        ],
      ),
    );
  }

  Future<void> processCheckLogin() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
          Get.off(const MainHome());
        })
        .catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, subTitle: onError.message);
    });
  }
}
