import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/product.dart';

class ProductServices {
  // create product method
  createProductDoc(ProductModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .add(model.toJson());
      return 'success';
    } catch (e) {
      print("Err in createProductDoc: $e");
      return null;
    }
  }
}
