// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:productexpire/utility/my_constant.dart';

class WidgetIconBitton extends StatelessWidget {
  final IconData iconData;
  final Function() pressFunc;
  final Color? color;
  final double? size;
  const WidgetIconBitton({
    Key? key,
    required this.iconData,
    required this.pressFunc,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: pressFunc,
        icon: Icon(
          iconData,
          color: color ?? MyConstant.active,
          size: size,
        ));
  }
}
