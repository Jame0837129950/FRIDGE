// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/widgets/widget_text.dart';

class WidgetTextButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  const WidgetTextButton({
    Key? key,
    required this.label,
    required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: pressFunc,
        child: WidgetText(
          text: label,
          textStyle: MyConstant().h2Style(color: MyConstant.active),
        ));
  }
}
