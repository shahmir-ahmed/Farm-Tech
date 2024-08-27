import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/buyer.dart';

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
}
