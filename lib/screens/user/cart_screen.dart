import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';

class CartScreen extends StatefulWidget {
  final CartService cartService;
  const CartScreen({required this.cartService});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _placeOrder() async {
    final orderService = OrderService();
    await orderService.placeOrder(widget.cartService.items);

    setState(() {
      widget.cartService.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Buyurtma yuborildi!')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartService.items;

    return Scaffold(
      appBar: AppBar(title: Text('Savatcha')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Soni: ${item.quantity}'),
                  trailing: Text('${item.total.toStringAsFixed(0)} so‘m'),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Jami: ${widget.cartService.total.toStringAsFixed(0)} so‘m',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: cartItems.isEmpty ? null : _placeOrder,
                  child: Text('Buyurtma berish'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
