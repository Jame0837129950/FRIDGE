// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productexpire/models/product_model.dart';

import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_dialog.dart';
import 'package:productexpire/utility/my_service.dart';
import 'package:productexpire/widgets/widget_button.dart';
import 'package:productexpire/widgets/widget_icon_button.dart';
import 'package:productexpire/widgets/widget_image.dart';
import 'package:productexpire/widgets/widget_text.dart';

class AddProduct extends StatefulWidget {
  final String docIdUser;
  const AddProduct({
    Key? key,
    required this.docIdUser,
  }) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  DateTime dateTime = DateTime.now();
  DateTime? expireDatetime;
  File? file;
  String? docIdUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docIdUser = widget.docIdUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: ListView(
        children: [
          contentImage(),
          showTitle(title: 'Receive'),
          showDateTime(dateTime: dateTime),
          showTitle(title: 'Expire :'),
          showDateTime(
            titleWidget: WidgetIconBitton(
              iconData: Icons.calendar_month,
              pressFunc: () async {
                expireDatetime = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: dateTime,
                    lastDate: DateTime(dateTime.year + 3));
                setState(() {});
              },
            ),
          ),
          buttonAddNewProduct(),
        ],
      ),
    );
  }

  Row buttonAddNewProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 36),
          width: 250,
          child: WidgetButton(
            label: 'Add New Product',
            pressFunc: () {
              if (file == null) {
                MyDialog(context: context).normalDialog(
                    title: 'No Image ?', subTitle: 'Please Take Photo');
              } else if (expireDatetime == null) {
                MyDialog(context: context).normalDialog(
                    title: 'Expire Date ?',
                    subTitle: 'Please Choose Expire Date');
              } else {
                ProcessUploadAndInsert();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget showDateTime({DateTime? dateTime, Widget? titleWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          child: ListTile(
            title: WidgetText(
              text: dateTime == null
                  ? expireDatetime == null
                      ? 'dd/MM/yyyy'
                      : MyService().dateToString(dateTime: expireDatetime!)
                  : MyService().dateToString(dateTime: dateTime),
            ),
            trailing: titleWidget,
          ),
        ),
      ],
    );
  }

  Container showTitle({required String title}) => Container(
        margin: const EdgeInsets.only(left: 36),
        child: WidgetText(
          text: title,
          textStyle: MyConstant().h2Style(),
        ),
      );

  Row contentImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 36),
          width: 250,
          height: 250,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: file == null
                    ? const WidgetImage(path: 'images/milk.png')
                    : Image.file(file!),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: WidgetIconBitton(
                  iconData: Icons.add_a_photo,
                  size: 48,
                  pressFunc: () async {
                    var result = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      maxWidth: 800,
                      maxHeight: 800,
                    );
                    if (result != null) {
                      file = File(result.path);
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar newAppBar() {
    return AppBar(
      title: WidgetText(
        text: 'Add New Product',
        textStyle: MyConstant().h2Style(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> ProcessUploadAndInsert() async {
    String nameFile = '$docIdUser${Random().nextInt(1000000)}.jpg';
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('product/$nameFile');
    UploadTask uploadTask = reference.putFile(file!);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((value) async {
        String urlImage = value;
        print('urlImage = $urlImage');

        DateTime receiveDateTime =
            DateTime(dateTime.year, dateTime.month, dateTime.day);
        expireDatetime = DateTime(
            expireDatetime!.year, expireDatetime!.month, expireDatetime!.day);

        ProductModel productModel = ProductModel(
            urlImage: urlImage,
            timeReceive: Timestamp.fromDate(receiveDateTime),
            timeExpire: Timestamp.fromDate(expireDatetime!));
        await FirebaseFirestore.instance
            .collection('user')
            .doc(docIdUser)
            .collection('product')
            .doc()
            .set(productModel.toMap())
            .then((value) => Get.back() );
      });
    });
  }
}
