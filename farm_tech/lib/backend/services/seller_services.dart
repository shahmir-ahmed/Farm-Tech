import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/seller.dart';

class SellerServices {
  Future createUserData(UserModel model, String userID) async {
    // await FirebaseFirestore.instance.collection('sellers').doc(userID).set(model.toJson());
    await FirebaseFirestore.instance.collection('sellers').add(model.toJson());
  }

  Stream<List<UserModel>> getAllSellers() {
    return FirebaseFirestore.instance.collection('sellers').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }
}
