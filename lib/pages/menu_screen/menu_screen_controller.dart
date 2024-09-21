import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';

class MenuScreenController extends GetxController {

  @override
  void onInit() {
    fetchBreakfastMenuData();
    super.onInit();
  }


  RxBool isVeg = false.obs;
  RxBool isNonVeg = false.obs;

  List<ProductModel> breakfastMenuList = [];
  late ProductModel productModel;
  List<ProductModel> search = [];

  productModels(QueryDocumentSnapshot element) {
    productModel = ProductModel(
      productImage: element.get("productImage"),
      productName: element.get("productName"),
      productPrice: element.get("productPrice"),
      productId: element.get("productId"),
    );
    search.add(productModel);
  }

  fetchBreakfastMenuData() async {
    List<ProductModel> newList = [];

    QuerySnapshot value =
        await FirebaseFirestore.instance.collection("Breakfast").get();

    for (var element in value.docs) {
      productModels(element);
      newList.add(productModel);
      // print("aabbcc");
      // print(newList.last.productImage);

    }
    breakfastMenuList = newList;
    update();
  }

  List<ProductModel> get getBreakfastMenuDataList {
    return breakfastMenuList;
  }

  ProductModel? getProductById(String productId) {
    try {
      return breakfastMenuList.firstWhere(
            (product) => product.productId == productId,
      );
    } catch (e) {
      return null; // Return null if productId is not found
    }
  }

  /////////////////// Search Return ////////////
  List<ProductModel> get gerAllProductSearch {
    return search;
  }
}
