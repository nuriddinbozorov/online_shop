import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';

class OrderService {
  Future<void> placeOrder(List<CartItem> items) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final order = {
      'userId': user.uid,
      'createdAt': Timestamp.now(),
      'total': items.fold(0, (sum, item) => sum + ((item?.total ?? 0).toInt())),
      //                                         ↑ double ni int ga convert qilish
      'items':
          items
              .map(
                (item) => {
                  'productId': item.product.id,
                  'name': item.product.name,
                  'price': item.product.price,
                  'quantity': item.quantity,
                },
              )
              .toList(),
    };

    await FirebaseFirestore.instance.collection('orders').add(order);
  }
}
