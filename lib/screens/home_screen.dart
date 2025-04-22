import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import '../models/product.dart';
import '../services/nfc_service.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mahsulotlar'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          Product product = dummyProducts[index];
          return ListTile(
            leading: Image.network(product.imageUrl),
            title: Text(product.name),
            subtitle: Text('${product.price.toStringAsFixed(0)} so‘m'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsScreen(product: product),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.nfc),
        onPressed: () async {
          final tag = await NfcService.readTag();
          if (tag != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Aniqlandi: $tag')));
            // Bu yerda tag orqali mahsulotni aniqlab, savatchaga qo‘shish mumkin
          }
        },
      ),
    );
  }
}
