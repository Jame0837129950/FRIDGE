// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/widgets/widget_image.dart';
import 'package:productexpire/widgets/widget_listtile.dart';
import 'package:productexpire/widgets/widget_text_button.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  void normalDialog({required String title, required String subTitle, Widget? actionWidget}) {
    Get.dialog(
      AlertDialog(
        title: WidgettListtitle(
          title: title,
          subTitle: subTitle,
          leadWidget: const WidgetImage(
            size: 80,
          ),
        ),
        actions: [
          actionWidget ??  const SizedBox(),
          WidgetTextButton(
            label: 'Cancel',
            pressFunc: () {
              Get.back();
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
