import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/product_reviews_model.dart';
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
  Future? uploadProductImage(String imageName, String imageUrl) async {
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
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      print('Err in getProductsStream: $e');
      return null;
    }
  }

  // get and return product image required
  Future? getProductImage(String imageName) async {
    try {
      // get product image path from storage
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(imageName);

      final imageUrl = await ref.getDownloadURL();

      // if no error occured while getting download url means url is present then set
      return imageUrl;
    } catch (e) {
      // print error
      print("ERR in getProductImage: ${e.toString()}");
      return null;
    }
  }

  // get a product stream
  Stream<ProductModel>? getProductStream(ProductModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('products')
          .doc(model.docId)
          .snapshots()
          .map((doc) => ProductModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id));
    } catch (e) {
      print('Err in getProductsStream: $e');
      return null;
    }
  }

  // get product reviews data stream
  Stream<ProductReviewsModel>? getProductReviewsDataStream(ProductModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('productReviews')
          .where('productId', isEqualTo: model.docId)
          .snapshots()
          .map((snapshot) {
        // if there are product reviews
        if (snapshot.docs.isNotEmpty) {
          // print('doc.data(): ${doc.data()}');

          // calculating avg rating
          // taking the stars count of each review doc as int into list
          final starsList = snapshot.docs.map((doc) {
            return int.parse(doc.get('starsCount'));
          }).toList();

          // print('starsList $starsList');

          // adding all stars count
          // adding each value into previous value with initial value set to 0
          final totalStarsCount = starsList.fold(
              0, (previousValue, element) => previousValue + element);
          // print('totalStarsCount $totalStarsCount');

          // dividing total by length of doc to calculate avg rating for the seller
          final avgRating = (totalStarsCount / snapshot.docs.length).floorToDouble();
          // final avgRating = double.parse((totalStarsCount / snapshot.docs.length).toStringAsFixed(1));
          // final avgRating = ((totalStarsCount / snapshot.docs.length) * 10)
          //         .truncateToDouble() /
          //     10;
          // print('avgRating $avgRating');

          // returning seller model having total reviews count and average rating
          return ProductReviewsModel(avgRating: avgRating.toString());
        } else {
          return ProductReviewsModel(avgRating: "0");
        }
      });
    } catch (e) {
      print('Err in getProductReviewsDataStream: $e');
      return null;
    }
  }
}
