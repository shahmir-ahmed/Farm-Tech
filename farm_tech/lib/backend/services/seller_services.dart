import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/seller.dart';
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

  // get and return seller profile image for shop screen
  Future<SellerModel?> getProfileImage(SellerModel model) async {
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
      return SellerModel(
          profileImageUrl:
              imageUrl); // set the image oath on the profile image of this object
    } catch (e) {
      // print error
      print("ERR in getProfileImage: ${e.toString()}");
      return null;
    }
  }
}
