import 'package:flutter/material.dart';
import 'package:productexpire/utility/my_constant.dart';

class WidgetProcess extends StatelessWidget {
  const WidgetProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: MyConstant.active,));
  }
}