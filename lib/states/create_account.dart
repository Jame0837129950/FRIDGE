import 'package:flutter/material.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/widgets/widget_button.dart';
import 'package:productexpire/widgets/widget_form.dart';
import 'package:productexpire/widgets/widget_text.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(
          text: 'Create New Account',
          textStyle: MyConstant().h2Style(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 36, right: 36, top: 75),
        children: [
          WidgetForm(
            hint: 'Name :',
            iconData: Icons.fingerprint,
            changeFunc: (p0) {},
          ),
          const SizedBox(
            height: 16,
          ),
          WidgetForm(
            hint: 'Email :',
            iconData: Icons.email,
            changeFunc: (p0) {},
          ),
          const SizedBox(
            height: 16,
          ),
          WidgetForm(
            hint: 'Password :',
            iconData: Icons.lock,
            changeFunc: (p0) {},
          ),
          const SizedBox(
            height: 16,
          ),
          WidgetButton(
            label: 'Create New Account',
            pressFunc: () {},
          )
        ],
      ),
    );
  }
}
