import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/order.dart';
import 'package:farm_tech/backend/model/seller.dart';

class OrderServices {
  // create order
  Future<String?> createOrder(OrderModel orderModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .add(orderModel.toJson());
      return 'success';
    } catch (e) {
      print('Error in createOrder: $e');
      return null;
    }
  }

  // get all orders stream
  Stream<List<OrderModel>?>? getAllOrdersStream(SellerModel sellerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerModel.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      print('Error in getAllOrdersStream: $e');
      return null;
    }
  }

  // get in progress orders stream
  Stream<List<OrderModel>?>? getInProgressOrdersStream(
      SellerModel sellerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerModel.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((doc) => doc.get('status') == "In Progress")
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      print('Error in getAllOrdersStream: $e');
      return null;
    }
  }

  // update order status
  updateOrderStatus(OrderModel orderModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderModel.docId)
          .update({"status": orderModel.status});

      return 'success';
    } catch (e) {
      print('Error in getAllOrdersStream: $e');
      return null;
    }
  }

  // get seller orders count which are sold (means status as completed) stream / total orders count in home screen
  Stream<String?>? getSellerSoldItemsStream(SellerModel sellerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerModel.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((doc) => doc.get('status') == "Completed")
              .length
              .toString());
    } catch (e) {
      print('Error in getSellerSoldItemsStream: $e');
      return null;
    }
  }

  // get seller orders count which are sold (means status as completed) count
  Future<String?>? getSellerSoldItemsCount(SellerModel sellerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerModel.docId)
          .get()
          .then((snapshot) => snapshot.docs
              .where((doc) => doc.get('status') == "Completed")
              .length
              .toString());
    } catch (e) {
      print('Error in getSellerSoldItemsCount: $e');
      return null;
    }
  }

  // get seller total earned count stream
  Stream<String?>? getSellerTotalEarnedStream(SellerModel sellerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerModel.docId) // seller orders
          .snapshots()
          .map((snapshot) {
        // taking the total amount value of each complted order doc as int into list
        final earningsList = snapshot.docs.map((doc) {
          if (doc.get('status') == "Completed") {
            return int.parse(doc.get('totalAmount'));
          } else {
            return 0;
          }
        }).toList();

        // adding each value into previous value with initial value set to 0
        final totalEarningsCount = earningsList.fold(
            0, (previousValue, element) => previousValue + element);

        return totalEarningsCount.toString();
      });
    } catch (e) {
      print('Error in getSellerTotalEarnedStream: $e');
      return null;
    }
  }
}
