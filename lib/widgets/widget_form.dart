// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  final String hint;
  final IconData iconData;
  final bool? obsecu;
  final Function(String) changeFunc;
  const WidgetForm({
    Key? key,
    required this.hint,
    required this.iconData,
    this.obsecu,
    required this.changeFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(onChanged: changeFunc,
      obscureText: obsecu ?? false,
      decoration: InputDecoration(
        suffixIcon: Icon(iconData),
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(),
      ),
    );
  }
}
