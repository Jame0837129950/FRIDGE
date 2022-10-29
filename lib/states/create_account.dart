import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/models/user_model.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_dialog.dart';
import 'package:productexpire/widgets/widget_button.dart';
import 'package:productexpire/widgets/widget_form.dart';
import 'package:productexpire/widgets/widget_text.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? name, email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'Create New Account',
          textStyle: MyConstant().h2Style(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: ListView(
          padding: const EdgeInsets.only(left: 36, right: 36, top: 75),
          children: [
            WidgetForm(
              hint: 'Name :',
              iconData: Icons.fingerprint,
              changeFunc: (p0) {
                name = p0.trim();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            WidgetForm(
              hint: 'Email :',
              iconData: Icons.email,
              changeFunc: (p0) {
                email = p0.trim();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            WidgetForm(
              hint: 'Password :',
              iconData: Icons.lock,
              changeFunc: (p0) {
                password = p0.trim();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            WidgetButton(
              label: 'Create New Account',
              pressFunc: () {
                if ((name?.isEmpty ?? true) ||
                    (email?.isEmpty ?? true) ||
                    (password?.isEmpty ?? true)) {
                  MyDialog(context: context).normalDialog(
                      title: 'Have Space ?',
                      subTitle: 'Please Fill Every Blank');
                } else {
                  processCreateAccount();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> processCreateAccount() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      String uid = value.user!.uid;
      print('uid ==> $uid');

      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();
      print('token ==> $token');

      UserModel userModel = UserModel(
          name: name!, token: token!, email: email!, password: password!);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(userModel.toMap())
          .then((value) => Get.back());
    }).catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, subTitle: onError.message);
    });
  }
}
