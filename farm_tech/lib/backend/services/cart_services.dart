import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/model/cart_item.dart';

class CartServices {
  // add item to carts collection with buyer id
  addItemToCart(CartItemModel cartModel) async {
    try {
      // check if already same product is added in cart then increase the quanity and total in existing cart item
      return await FirebaseFirestore.instance
          .collection('carts')
          .where('buyerId', isEqualTo: cartModel.buyerId)
          .where('productId', isEqualTo: cartModel.productId)
          .get()
          .then((snapshot) async {
        // if same product cart item is present in user cart then merge quantity and total
        if (snapshot.docs.isNotEmpty) {
          // add quanity
          final newQuantity = int.parse(snapshot.docs.first.get('quantity')) +
              int.parse(cartModel.quantity!);

          // add total
          final newTotal = int.parse(snapshot.docs.first.get('total')) +
              int.parse(cartModel.total!);

          // new cart item model
          final updatedCartItemModel = CartItemModel(
              quantity: newQuantity.toString(),
              total: newTotal.toString(),
              buyerId: cartModel.buyerId,
              productId: cartModel.productId,
              createdAt: snapshot.docs.first.get('createdAt') // same createdAt
              );

          // update cart item
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(snapshot.docs.first.id)
              .update(updatedCartItemModel.toJson());

          return snapshot.docs.first.id;
        } else {
          // create new cart item doc
          final docRef = await FirebaseFirestore.instance
              .collection('carts')
              .add(cartModel.toJson());

          return docRef.id;
        }
      });

      // return 'success';
    } catch (e) {
      print('Error in addItemToCart: $e');
      return null;
    }
  }

  // remove item from carts collection
  removeItemFromCart(CartItemModel cartModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartModel.docId).delete();

      return 'success';
    } catch (e) {
      print('Error in removeItemFromCart: $e');
      return null;
    }
  }

  // return cart items stream of a buyer
  Stream<List<CartItemModel>?>? getBuyerCartItemsStream(BuyerModel buyerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('carts')
          .where('buyerId', isEqualTo: buyerModel.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CartItemModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      print('Error in getCartItemsStream: $e');
      return null;
    }
  }

  // return cart items stream of a buyer
  Stream<int?>? getBuyerCartItemsCountStream(BuyerModel buyerModel) {
    try {
      return FirebaseFirestore.instance
          .collection('carts')
          .where('buyerId', isEqualTo: buyerModel.docId)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      print('Error in getBuyerCartItemsCountStream: $e');
      return null;
    }
  }
}
