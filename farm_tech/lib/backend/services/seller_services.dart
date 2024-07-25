import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/seller.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class SellerServices {
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

      await ref.putFile(File(sellerModel.profileImageUrl as String)); // put image at the ref

      return 'success';
    } catch (e) {
      // print error
      print("ERR in uploadProfileImage: ${e.toString()}");
      return 'error';
    }
  }

  // Stream<List<UserModel>> getAllSellers() {
  //   return FirebaseFirestore.instance.collection('sellers').snapshots().map(
  //       (snapshot) => snapshot.docs
  //           .map((doc) => UserModel.fromJson(doc.data()))
  //           .toList());
  // }
}
