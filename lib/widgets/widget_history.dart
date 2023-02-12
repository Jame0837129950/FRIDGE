import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/controllors/app_controller.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_service.dart';
import 'package:productexpire/widgets/widget_text.dart';

class WidgetHistory extends StatefulWidget {
  const WidgetHistory({super.key});

  @override
  State<WidgetHistory> createState() => _WidgetHistoryState();
}

class _WidgetHistoryState extends State<WidgetHistory> {
  @override
  void initState() {
    super.initState();
    MyService().readAllProductExpire();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return GetX(
          init: AppController(),
          builder: (AppController appController) {
            print(
                '##11feb productModels --> ${appController.productModels.length}');
            return appController.productModels.isEmpty
                ? const SizedBox()
                : ListView.builder(itemCount: appController.productModels.length,
                    itemBuilder: (context, index) => displayProduct(
                        boxConstraints: boxConstraints,
                        index: index,
                        appController: appController),
                  );
          });
    });
  }

  Column displayProduct(
      {required BoxConstraints boxConstraints,
      required int index,
      required AppController appController}) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              width: boxConstraints.maxWidth * 0.5,
              height: boxConstraints.maxWidth * 0.5,
              child: Image.network(
                appController.productModels[index].urlImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              width: boxConstraints.maxWidth * 0.5,
              height: boxConstraints.maxWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetText(
                    text: 'Expire Date :',
                    textStyle: MyConstant().h2Style(),
                  ),
                  WidgetText(
                    text: MyService().dateToString(
                        dateTime: appController.productModels[index].timeExpire
                            .toDate()),
                    textStyle: MyConstant().h3Style(color: MyConstant.active),
                  ),
                  WidgetText(
                    text: 'Receive Date :',
                    textStyle: MyConstant().h2Style(),
                  ),
                  WidgetText(
                      text: MyService().dateToString(
                          dateTime: appController
                              .productModels[index].timeReceive
                              .toDate())),
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: MyConstant.dark,
        )
      ],
    );
  }
}
