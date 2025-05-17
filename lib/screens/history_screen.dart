import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatelessWidget {
  Stream<QuerySnapshot> getUserOrders() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user?.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buyurtmalar tarixi")),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Xatolik yuz berdi'));
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(child: Text("Sizda hali buyurtmalar mavjud emas"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final createdAt = (order['createdAt'] as Timestamp).toDate();
              final total = order['total'];
              final items = List.from(order['items']);

              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    "${createdAt.day}.${createdAt.month}.${createdAt.year} - $total so‘m",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children:
                      items.map<Widget>((item) {
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text('Soni: ${item['quantity']}'),
                          trailing: Text('${item['price']} so‘m'),
                        );
                      }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
