import 'package:get/get.dart';
import 'package:productexpire/models/product_model.dart';
import 'package:productexpire/models/user_model.dart';

class AppController extends GetxController {
  RxInt indexBodyMainHome = 0.obs;
  

  RxList productModels = <ProductModel>[].obs;

  

  RxList nonExprieProductModels = <ProductModel>[].obs;
  RxList docIdNonExpireProducts = <String>[].obs;

  RxList userModels = <UserModel>[].obs;
}