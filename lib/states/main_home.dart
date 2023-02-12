import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:productexpire/controllors/app_controller.dart';
import 'package:productexpire/models/product_model.dart';
import 'package:productexpire/utility/my_constant.dart';
import 'package:productexpire/utility/my_dialog.dart';
import 'package:productexpire/utility/my_service.dart';
import 'package:productexpire/widgets/widget_history.dart';
import 'package:productexpire/widgets/widget_image.dart';
import 'package:productexpire/widgets/widget_list_product.dart';
import 'package:productexpire/widgets/widget_listtile.dart';
import 'package:productexpire/widgets/widget_text.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var titles = <String>[
    'List Product',
    'History',
  ];

  var bodys = <Widget>[
    const WidgetListProduct(),
    const WidgetHistory(),
  ];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  InitializationSettings? initializationSettings;
  AndroidInitializationSettings? androidInitializationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupLocalNoti();
    checkExpireDate();
    MyService().readAllProductExpire().then((value) {
      alertProductExpire();
    });
    MyService().findUserModels();
  }

  Future<void> setupLocalNoti() async {
    androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings!);
  }

  Future<void> processDisplayLocalNoti() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channelId',
      'channelName',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'expire',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Have Product Expire', 'Detail Expire', notificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: AppController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: WidgetText(
            text: titles[controller.indexBodyMainHome.value],
            textStyle: MyConstant().h2Style(color: Colors.black),
          ),
        ),
        drawer: newDarwer(controller: controller),
        body: bodys[controller.indexBodyMainHome.value],
      ),
    );
  }

  Widget newDarwer({required AppController controller}) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: controller.userModels.isEmpty
                ? const SizedBox()
                : WidgetText(
                    text: controller.userModels.last.name,
                    textStyle: MyConstant().h2Style(color: Colors.white),
                  ),
            accountEmail: controller.userModels.isEmpty
                ? const SizedBox()
                : WidgetText(
                    text: controller.userModels.last.email,
                    textStyle: MyConstant().h3Style(color: Colors.white),
                  ),
            currentAccountPicture: WidgetImage(),
          ),
          WidgettListtitle(
            title: 'List Product',
            leadWidget: const WidgetImage(
              path: 'images/list.png',
              size: 48,
            ),
            subTitle: 'List All Product And Add New Product',
            tapFunc: () {
              controller.indexBodyMainHome.value = 0;
              Get.back();
            },
          ),
          WidgettListtitle(
            title: 'History',
            leadWidget: const WidgetImage(
              path: 'images/history.png',
              size: 48,
            ),
            subTitle: 'List Peoduct History',
            tapFunc: () {
              controller.indexBodyMainHome.value = 1;
              Get.back();
            },
          ),
          const Spacer(),
          Divider(
            color: MyConstant.dark,
          ),
          WidgettListtitle(
            title: 'Sign Out',
            subTitle: 'Sign Out And Move To Authen Page',
            leadWidget: const WidgetImage(
              path: 'images/sign out.png',
              size: 48,
            ),
            tapFunc: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Get.offAllNamed('/authen');
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> checkExpireDate() async {
    DateTime currentDateTime = DateTime.now();
    currentDateTime = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, MyConstant.hour, MyConstant.mimus);

    var user = FirebaseAuth.instance.currentUser;

    var productModels = <ProductModel>[];

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('product')
        .orderBy('timeExpire')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          ProductModel model = ProductModel.fromMap(element.data());
          productModels.add(model);
        } // for

        DateTime expireDatetime = productModels[0].timeExpire.toDate();
        expireDatetime = DateTime(expireDatetime.year, expireDatetime.month,
            expireDatetime.day, MyConstant.hour, MyConstant.mimus);
        print('currentDateTime ==> $currentDateTime');
        print('expireDatetime ==> $expireDatetime');

        if (expireDatetime.isAfter(currentDateTime)) {
          print('ยังไม่หมดอายุ');
        } else {}
      } // if
    });
  }

  Future<void> alertProductExpire() async {
    print('##11feb หมดอายุแล้ว');

    AppController appController = Get.put(AppController());

    if (appController.nonExprieProductModels.isNotEmpty) {
      DateTime nearExpireDateTime =
          appController.nonExprieProductModels[0].timeExpire.toDate();

      nearExpireDateTime = DateTime(
          nearExpireDateTime.year,
          nearExpireDateTime.month,
          (nearExpireDateTime.day - 1),
          MyConstant.hour,
          MyConstant.mimus,
          0);

      print('##11feb หมดอายุแล้ว $nearExpireDateTime');

      await Future.delayed(
        nearExpireDateTime.difference(DateTime.now()),
        // Duration(seconds: 10),
        () {
          MyDialog(context: context).normalDialog(
              title: 'Have Product Expire', subTitle: 'Some Product Expire');

          processDisplayLocalNoti();
        },
      );
    }

    // DateTime dateTime = DateTime.now();
    // DateTime alertDatetime = DateTime(dateTime.year, dateTime.month,
    //     dateTime.day, MyConstant.hour, MyConstant.mimus);
  }
}
