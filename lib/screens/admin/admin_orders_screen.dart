import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersScreen extends StatelessWidget {
  Stream<QuerySnapshot> getAllOrders() {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Barcha buyurtmalar")),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Xatolik yuz berdi'));
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final createdAt = (order['createdAt'] as Timestamp).toDate();
              final status = order['status'];
              final userId = order['userId'];
              final total = order['total'];
              final items = List.from(order['items']);

              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    "$userId\n${createdAt.day}.${createdAt.month}.${createdAt.year} - $total so‘m",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Status: $status"),
                  children: [
                    ...items.map<Widget>((item) {
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text('Soni: ${item['quantity']}'),
                        trailing: Text('${item['price']} so‘m'),
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: status,
                        decoration: InputDecoration(
                          labelText: 'Statusni yangilash',
                        ),
                        items:
                            ['Yangi', 'Jarayonda', 'Yuborildi', 'Yetkazildi']
                                .map(
                                  (status) => DropdownMenuItem(
                                    child: Text(status),
                                    value: status,
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            order.reference.update({'status': value});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
