import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/review.dart';

class ReviewServices {
  // get all product reviews
  Stream<List<ReviewModel>>? getAllProductReviews(ProductModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('productReviews')
          .where('productId', isEqualTo: model.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      // print error
      print("ERR in getAllProductReviews: ${e.toString()}");
      return null;
    }
  }
}
