import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.imageUrl),
            SizedBox(height: 16),
            Text(product.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(
              '${product.price.toStringAsFixed(0)} so‘m',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                cart.addToCart(product);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Savatchaga qo‘shildi')));
              },
              child: Text('Savatchaga qo‘shish'),
            ),
          ],
        ),
      ),
    );
  }
}
