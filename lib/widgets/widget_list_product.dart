import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/models/product_model.dart';
import 'package:productexpire/states/add_product.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_service.dart';
import 'package:productexpire/widgets/widget_icon_button.dart';
import 'package:productexpire/widgets/widget_image.dart';
import 'package:productexpire/widgets/widget_process.dart';
import 'package:productexpire/widgets/widget_text.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return SizedBox(
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: Stack(
          children: [
            
            load
                ? const WidgetProcess()
                : haveProduct!
                    ? ListView.builder(
                        itemCount: productModels.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  width: boxConstraints.maxWidth * 0.5,
                                  height: boxConstraints.maxHeight * 0.4,
                                  child: Image.network(
                                    productModels[index].urlImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  width: boxConstraints.maxWidth * 0.5,
                                  height: boxConstraints.maxHeight * 0.4,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WidgetText(
                                        text: 'Expire Date :',
                                        textStyle: MyConstant().h2Style(),
                                      ),
                                      WidgetText(
                                        text: MyService().dateToString(
                                            dateTime: productModels[index]
                                                .timeExpire
                                                .toDate()),
                                        textStyle: MyConstant()
                                            .h3Style(color: MyConstant.active),
                                      ),
                                      WidgetText(
                                        text: 'Receive Date :',
                                        textStyle: MyConstant().h2Style(),
                                      ),
                                      WidgetText(
                                          text: MyService().dateToString(
                                              dateTime: productModels[index]
                                                  .timeReceive
                                                  .toDate())),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: MyConstant.dark,)
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const WidgetImage(
                              path: 'images/list.png',
                              size: 250,
                            ),
                            WidgetText(
                              text: 'No Product',
                              textStyle: MyConstant().h1Style(),
                            ),
                          ],
                        ),
                      ),
                      ButtonAddNewProduct(),
          ],
        ),
      );
    });
  }

  Positioned ButtonAddNewProduct() {
    return Positioned(
      bottom: 36,
      right: 36,
      child: WidgetIconBitton(
        iconData: Icons.add_box,
        pressFunc: () {
          Get.to(AddProduct(docIdUser: user!.uid))?.then((value) {
            readAllProduct();
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
