import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/buyer.dart';

class BuyerServices{
  // create buyer document in firestore
  Future createBuyerDoc(BuyerModel model, String uId) async {
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
  Future<String?> getBuyerName(BuyerModel model) async {
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
}