import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/controllors/app_controller.dart';
import 'package:productexpire/models/product_model.dart';
import 'package:productexpire/states/add_product.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_dialog.dart';
import 'package:productexpire/utility/my_service.dart';
import 'package:productexpire/widgets/widget_icon_button.dart';
import 'package:productexpire/widgets/widget_image.dart';
import 'package:productexpire/widgets/widget_process.dart';
import 'package:productexpire/widgets/widget_text.dart';
import 'package:productexpire/widgets/widget_text_button.dart';

class WidgetListProduct extends StatefulWidget {
  const WidgetListProduct({super.key});

  @override
  State<WidgetListProduct> createState() => _WidgetListProductState();
}

class _WidgetListProductState extends State<WidgetListProduct> {
  var user = FirebaseAuth.instance.currentUser;

  bool load = true;
  bool? haveProduct;
  var productModels = <ProductModel>[];

  @override
  void initState() {
    super.initState();
    readAllProduct();
    MyService().readAllProductExpire();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return SizedBox(
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: Stack(
          children: [
            GetX(
                init: AppController(),
                builder: (AppController appController) {
                  print(
                      'nonExpireProductModels --> ${appController.nonExprieProductModels.length}');
                  return appController.nonExprieProductModels.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          itemCount:
                              appController.nonExprieProductModels.length,
                          itemBuilder: (context, index) => displayProduct(
                              boxConstraints: boxConstraints,
                              index: index,
                              appController: appController),
                        );
                }),
            buttonAddNewProduct(),
          ],
        ),
      );
    });
  }

  Column displayProduct(
      {required BoxConstraints boxConstraints,
      required int index,
      required AppController appController}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              width: boxConstraints.maxWidth * 0.5,
              height: boxConstraints.maxWidth * 0.5,
              child: Image.network(
                appController.nonExprieProductModels[index].urlImage,
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
                        dateTime: appController
                            .nonExprieProductModels[index].timeExpire
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
                              .nonExprieProductModels[index].timeReceive
                              .toDate())),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      WidgetIconBitton(
                        iconData: Icons.delete_forever,
                        pressFunc: () {
                          MyDialog(context: context).normalDialog(
                              title: 'Delete ?',
                              subTitle: 'Please Confirm Delete',
                              actionWidget: WidgetTextButton(
                                label: 'Confirm Delete',
                                pressFunc: () async {
                                  print(
                                      'delete --> ${appController.docIdNonExpireProducts[index]}');
                                  MyService()
                                      .processDeleteProduct(
                                          docIdProductDelete: appController
                                              .docIdNonExpireProducts[index])
                                      .then((value) {
                                        Get.back();
                                      });
                                },
                              ));
                        },
                      ),
                    ],
                  )
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

  Positioned buttonAddNewProduct() {
    return Positioned(
      bottom: 36,
      right: 36,
      child: WidgetIconBitton(
        iconData: Icons.add_box,
        pressFunc: () {
          Get.to(AddProduct(docIdUser: user!.uid))?.then((value) {
            MyService().readAllProductExpire();
          });
        },
        size: 48,
      ),
    );
  }

  Future<void> readAllProduct() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
    }
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('product')
        .orderBy('timeExpire')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        haveProduct = false;
      } else {
        haveProduct = true;

        for (var element in value.docs) {
          ProductModel model = ProductModel.fromMap(element.data());
          productModels.add(model);
        }
      }

      load = false;
      setState(() {});
    });
  }
}
