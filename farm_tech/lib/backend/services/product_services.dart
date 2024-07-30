import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class ProductServices {
  // create product method
  createProductDoc(ProductModel model) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('products')
          .add(model.toJson());
      return docRef.id;
    } catch (e) {
      print("Err in createProductDoc: $e");
      return null;
    }
  }

  // upload product image method
  uploadProductImage(String imageName, String imageUrl) async {
    try {
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(
              imageName); // image name as id of product doc and if more than one image then underscore number with id

      await ref.putFile(File(imageUrl)); // put image at the ref
      return 'success';
    } catch (e) {
      print("Err in createProductDoc: $e");
      return null;
    }
  }

  // get seller products stream
  Stream<List<ProductModel>>? getProductsStream(SellerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: model.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList());
    } catch (e) {
      print('Err in getProductsStream: $e');
      return null;
    }
  }
}
