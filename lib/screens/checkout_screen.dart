import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Xaridni yakunlash')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children:
                    cart.items.map((item) {
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text(
                          '${item.quantity} × ${item.product.price.toStringAsFixed(0)} so‘m',
                        ),
                      );
                    }).toList(),
              ),
            ),
            Text(
              'Jami: ${cart.totalPrice.toStringAsFixed(0)} so‘m',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Xarid muvaffaqiyatli amalga oshirildi'),
                  ),
                );
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('To‘lovni amalga oshirish'),
            ),
          ],
        ),
      ),
    );
  }
}
