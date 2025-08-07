import 'package:flutter/material.dart';

// CheckoutPage widget to handle cart and order placement
class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final String title;
  final VoidCallback? onClearCart;
  final Function(List<Map<String, dynamic>>)? onPlaceOrder;

  const CheckoutPage({
    super.key, 
    required this.cart, 
    required this.title,
    this.onClearCart,
    this.onPlaceOrder,
  });

  // Helper function to calculate total price
  double _calculateTotal() {
    double total = 0;
    for (var item in cart) {
      String priceStr = item["price"]?.toString() ?? "0";
      // Remove any dollar sign and commas, then parse
      String cleaned = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
      double price = double.tryParse(cleaned) ?? 0;
      total += price;
    }
    return total;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final item = cart[index];
              return ListTile(
                title: Text(item["name"] ?? ""),
                subtitle: Text('\$${item["price"]?.toString() ?? "0"}'),
              );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${_calculateTotal().toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: cart.isEmpty
                  ? null
                  : () {
                      // Call the order placement callback
                      if (onPlaceOrder != null) {
                        onPlaceOrder!(cart);
                      }

                      // Then clear the cart
                      if (onClearCart != null) {
                        onClearCart!();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order placed!')),
                      );
                    },
              child: const Text('Buy'),
            ),
          )
        ],
      ),
    );
  }
}