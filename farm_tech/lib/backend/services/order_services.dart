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
}
