// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetImage extends StatelessWidget {
  final String? path;
  final double? size;
  const WidgetImage({
    Key? key,
    this.path,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path ?? 'images/logo.png',
      width: size,
      height: size,
    );
  }
}
