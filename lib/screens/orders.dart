import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final List<List<Map<String, dynamic>>> orders;
  final String title;

  const OrdersPage({
    super.key, 
    required this.title, 
    required this.orders
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders placed yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Order #${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: order.map((item) {
                        return Text('${item["name"]} - ${item["price"]}');
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}