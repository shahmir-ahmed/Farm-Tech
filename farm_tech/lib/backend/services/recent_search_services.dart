import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/recent_search.dart';

class RecentSearchServices {
  // create recent search doc for buyer
  addRecentSearch(RecentSearchModel model) async {
    try {
      // check if doc of this buyer with same search text exists then not create doc for this search text
      await FirebaseFirestore.instance
          .collection('recentSearches')
          .where('buyerId', isEqualTo: model.buyerId)
          .get()
          .then((snapshot) async {
        final sameTextDoc = snapshot.docs.where(
            (doc) => doc.get('searchText').toString() == model.searchText);

        if (sameTextDoc.length == 1) {
          // not create doc for this search text
          // but update the createdAt of this doc
          final newModel = RecentSearchModel(
              searchText: model.searchText,
              buyerId: model
                  .buyerId); // text and id is same as passed and createdAt will be updated by the toJson method
          // updating doc createdAt
          await FirebaseFirestore.instance
              .collection('recentSearches')
              .doc(sameTextDoc.first.id)
              .update(newModel.toJson());
        } else {
          // create doc for this search text because no doc with this search text exists
          await FirebaseFirestore.instance
              .collection('recentSearches')
              .add(model.toJson());
        }
      });

      return 'success';
    } catch (e) {
      print('Err in addRecentSearch: $e');
      return null;
    }
  }

  // delete all recent searches for buyer
  clearRecentSearches(String buyerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recentSearches')
          // .where('buyerId', isEqualTo: buyerId)
          .get()
          .then((snapshot) async {
        List<DocumentSnapshot> allDocs = snapshot.docs;
        List<DocumentSnapshot> filteredDocs = allDocs
            .where((document) => document.get('buyerId') == buyerId)
            .toList();
        for (DocumentSnapshot ds in filteredDocs) {
          await ds.reference.delete();
        }
      }
              // snapshot.docs.map((doc) async {
              // then one by one delete each doc (not working)
              // await FirebaseFirestore.instance
              //     .collection('recentSearches')
              //     .doc(doc.id)
              //     .delete();

              // }
              );

      return 'success';
    } catch (e) {
      print('Err in clearRecentSearches: $e');
      return null;
    }
  }

  // get recent searches for buyer
  Stream<List<RecentSearchModel>?>? getBuyerRecentSearches(String buyerId) {
    try {
      return FirebaseFirestore.instance
          .collection('recentSearches')
          .where('buyerId', isEqualTo: buyerId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => RecentSearchModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      print('Err in addRecentSearch: $e');
      return null;
    }
  }
}
