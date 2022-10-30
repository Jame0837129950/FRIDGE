import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productexpire/controllors/app_controller.dart';
import 'package:productexpire/utility/my_constant.dart';
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

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: AppController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: WidgetText(
            text: titles[controller.indexBodyMainHome.value],
            textStyle: MyConstant().h2Style(color: Colors.white),
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
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
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
}
