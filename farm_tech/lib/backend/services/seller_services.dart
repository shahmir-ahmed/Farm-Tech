import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:farm_tech/backend/model/seller_reviews_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class SellerServices {
  // create seller document in firestore
  Future createSellerDoc(SellerModel model, String uId) async {
    try {
      // create seller doc with the uid of auth credentials
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(uId)
          .set(model.toJson());

      return 'success';
    } catch (e) {
      print('Err in createSellerDoc: $e');
      return null;
    }
    // await FirebaseFirestore.instance.collection('sellers').add(model.toJson());
  }

  // upload profile image of seller
  Future uploadProfileImage(SellerModel sellerModel) async {
    try {
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('seller_profile_images')
          .child(sellerModel.docId as String); // image name as uid of seller

      await ref.putFile(
          File(sellerModel.profileImageUrl as String)); // put image at the ref

      return 'success';
    } catch (e) {
      // print error
      print("ERR in uploadProfileImage: ${e.toString()}");
      return 'error';
    }
  }

  // get individual seller data stream
  Stream<SellerModel>? getSellerDataStream(SellerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('sellers')
          .doc(model.docId)
          .snapshots()
          .map((doc) {
        // print('doc.data(): ${doc.data()}');
        return SellerModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      });
    } catch (e) {
      print('Err in getSellerDataStream: $e');
      return null;
    }
  }

  // get seller reviews data (avg rating and total reviews count) stream
  Stream<SellerReviewsModel>? getSellerReviewsDataStream(SellerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('productReviews')
          .where('sellerId', isEqualTo: model.docId)
          .snapshots()
          .map((snapshot) {
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
        final avgRating =
            (totalStarsCount / snapshot.docs.length).floorToDouble();
        // final avgRating = double.parse((totalStarsCount / snapshot.docs.length).toStringAsFixed(1));
        // final avgRating = ((totalStarsCount / snapshot.docs.length)* 10).truncateToDouble() / 10;
        // print('avgRating $avgRating');

        // returning seller model having total reviews count and average rating
        return SellerReviewsModel(
            totalReviewsCount: snapshot.docs.length.toString(),
            avgRating: avgRating.toString());
      });
    } catch (e) {
      print('Err in getSellerReviewsDataStream: $e');
      return null;
    }
  }

  // get seller total reviews count stream
  Stream<String?>? getTotalReviewsCountStream(SellerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('productReviews')
          .where('sellerId', isEqualTo: model.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs.length.toString());
    } catch (e) {
      print('Err in getSellerReviewsDataStream: $e');
      return null;
    }
  }

  // get individual seller name
  Future<String?> getSellerName(SellerModel model) async {
    try {
      return await FirebaseFirestore.instance
          .collection('sellers')
          .doc(model.docId)
          .get()
          .then((doc) {
        return doc.get('name').toString();
      });
    } catch (e) {
      print('Err in getSellerDataStream: $e');
      return null;
    }
  }

  // get individual seller name stream
  Stream<String?>? getSellerNameStream(SellerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('sellers')
          .doc(model.docId)
          .snapshots()
          .map((doc) => doc.get('name'));
    } catch (e) {
      print('Err in getSellerNameStream: $e');
      return null;
    }
  }

  // get and return seller profile image for shop screen
  Future<String?> getProfileImage(SellerModel model) async {
    try {
      // get profile image path from storage
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('seller_profile_images')
          .child(model.docId as String);

      // print('ref: $ref'); // to check what gets print when there is no image of this name : ref: Reference(app: [DEFAULT], fullPath: uni_profile_images/c4JoUpPtAvIYGcWZx6or.jpg)
      // print('here');
      final imageUrl = await ref.getDownloadURL();

      // if no error occured while getting download url means url is present then set
      return imageUrl; // set the image oath on the profile image of this object
    } catch (e) {
      // print error
      print("ERR in getProfileImage: ${e.toString()}");
      return null;
    }
  }

  // update seller profile image
  Future<String?> updateProfileImage(SellerModel model) async {
    try {
      // get profile image path from storage
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('seller_profile_images')
          .child(model.docId as String);

      await ref.delete(); // delete the current object at path and

      // put new file at the reference after deleting
      await ref.putFile(
          File(model.profileImageUrl!)); // put new file at the reference

      return 'success';
    } catch (e) {
      // print error
      print("ERR in updateProfileImage: ${e.toString()}");
      return null;
    }
  }

  // get individual seller products and return count
  Future<int?> getSellerProductsCount(SellerModel model) async {
    try {
      return await FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: model.docId)
          .get()
          .then((snapshot) => snapshot.docs.length);
    } catch (e) {
      print('Err in getSellerProductsCount: $e');
      return null;
    }
  }

  // update seller name
  Future<String?> updateSellerName(SellerModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(model.docId)
          .update({"name": model.name});

      return 'success';
    } catch (e) {
      print('Err in updateSellerName: $e');
      return null;
    }
  }
}
