import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/review.dart';
import 'package:farm_tech/backend/model/seller.dart';

class ReviewServices {
  // get all product reviews
  Stream<List<ReviewModel>>? getAllProductReviews(ProductModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('reviews')
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

  // get all seller reviews
  Stream<List<ReviewModel>>? getAllSellerReviews(SellerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('reviews')
          .where('sellerId', isEqualTo: model.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      // print error
      print("ERR in getAllSellerReviews: ${e.toString()}");
      return null;
    }
  }

  // create product review
  createReview(ReviewModel model) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('reviews')
          .add(model.toJson());
      return docRef.id;
    } catch (e) {
      print("Err in createReview: $e");
      return null;
    }
  }

  // check order review exists or not
  checkOrderReviewExists(ReviewModel model) async {
    try {
      return await FirebaseFirestore.instance
          .collection('reviews')
          .where('orderId', isEqualTo: model.orderId)
          .get()
          .then((snapshot) {
        // if order review doc exists
        if (snapshot.docs.length == 1) {
          return ReviewModel.fromJson(snapshot.docs.first.data(), snapshot.docs.first.id);
        } else {
          return false;
        }
      });
    } catch (e) {
      print("Err in checkOrderReviewExists: $e");
      return null;
    }
  }

  // get order review
  getOrderReview(ReviewModel model) async{
    return await FirebaseFirestore.instance
          .collection('reviews')
          .where('orderId', isEqualTo: model.orderId)
          .get()
          .then((snapshot) {
            snapshot.docs.map((doc) => OrderModel.fromJson(doc.data(), doc.id));
          }
            
      );
  }
}
