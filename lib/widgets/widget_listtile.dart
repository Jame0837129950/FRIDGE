// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/widgets/widget_text.dart';

class WidgettListtitle extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Widget leadWidget;
  final Function()? tapFunc;
  const WidgettListtitle({
    Key? key,
    required this.title,
    this.subTitle,
    required this.leadWidget,
    this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapFunc,
      child: ListTile(
        leading: leadWidget,
        title: WidgetText(
          text: title,
          textStyle: MyConstant().h2Style(),
        ),
        subtitle: WidgetText(text: subTitle ?? ''),
      ),
    );
  }
}
