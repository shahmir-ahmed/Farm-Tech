import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/buyer.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class BuyerServices {
  // create buyer document in firestore
  Future createDoc(BuyerModel model, String uId) async {
    try {
      // create seller doc with the uid of auth credentials
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(uId)
          .set(model.toJson());

      return 'success';
    } catch (e) {
      print('Err in createBuyerDoc: $e');
      return null;
    }
  }

  /*
  // check buyer with a specific doc id exists or not
  String? checkBuyerWithDocId(BuyerModel model) {
    try {
      FirebaseFirestore.instance
          .collection('buyers')
          .doc(model.docId)
          .toString();

      return 'success'; // if buyer with doc id exists then return success
    } catch (e) {
      print('Err in checkBuyerWithDocId: $e');
      return null;
    }
  }
  */

  // get individual buyer name
  Future<String?> getName(BuyerModel model) async {
    try {
      return await FirebaseFirestore.instance
          .collection('buyers')
          .doc(model.docId)
          .get()
          .then((doc) {
        return doc.get('name').toString();
      });
    } catch (e) {
      print('Err in getBuyerName: $e');
      return null;
    }
  }

  // get buyer address stream
  Stream<BuyerModel?>? getAddressStream(BuyerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('buyers')
          .doc(model.docId)
          .snapshots()
          .map((doc) {
        return BuyerModel(address: doc.get('address').toString());
      });
    } catch (e) {
      print('Err in getBuyerAddressStream: $e');
      return null;
    }
  }

  // get buyer name, contact stream
  Stream<BuyerModel?>? getNameContactStream(BuyerModel model) {
    try {
      return FirebaseFirestore.instance
          .collection('buyers')
          .doc(model.docId)
          .snapshots()
          .map((doc) {
        return BuyerModel(
          name: doc.get('name').toString(),
          contactNo: doc.get('contactNo').toString(),
        );
      });
    } catch (e) {
      print('Err in getBuyerAddressStream: $e');
      return null;
    }
  }

  // update buyer address
  Future updateAddress(BuyerModel model) async {
    try {
      // update buyer address only
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(model.docId)
          .update(model.addressToJson());

      return 'success';
    } catch (e) {
      print('Err in updateAddress: $e');
      return null;
    }
  }

  // get and return buyer profile image for profile tab
  Future<String?> getProfileImage(BuyerModel model) async {
    try {
      // get profile image path from storage
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('buyer_profile_images')
          .child(model.docId as String);

      // print('ref: $ref'); // to check what gets print when there is no image of this name : ref: Reference(app: [DEFAULT], fullPath: uni_profile_images/c4JoUpPtAvIYGcWZx6or.jpg)
      // print('here');
      final imageUrl = await ref.getDownloadURL();

      // if no error occured while getting download url means url is present then set
      return imageUrl;
    } catch (e) {
      // print error
      print("ERR in getProfileImage: ${e.toString()}");
      return null;
    }
  }

  // update buyer name
  Future<String?> updateName(BuyerModel model) async {
    try {
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(model.docId)
          .update({"name": model.name});

      return 'success';
    } catch (e) {
      print('Err in updateName: $e');
      return null;
    }
  }

  // update buyer profile image
  Future<String?> updateProfileImage(BuyerModel model) async {
    try {
      // get profile image path from storage
      final ref = storage.FirebaseStorage.instance
          .ref()
          .child('buyer_profile_images')
          .child(model.docId as String);

      try {
        await ref.delete(); // delete the current object at path and
      } catch (e) {
        // if file not present at path then deleting will cause error and cath it here
        print('Err deleting image at path: $e');
      }

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

  // check email with buyer doc exists or not
  checkEmailExists(BuyerModel model) async {
    try {
      return await FirebaseFirestore.instance
          .collection('buyers')
          .where('email', isEqualTo: model.email)
          .get()
          .then((snapshot) {
        // if seller exists the return true otherwise false
        if (snapshot.docs.length == 1) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print('Err in checkEmailExists: $e');
      return null;
    }
  }
}
