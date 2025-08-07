import 'package:marketplace/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/screens/profile.dart';
import 'package:marketplace/screens/login.dart';
import 'package:marketplace/screens/checkout.dart';
import 'package:marketplace/screens/orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sil marketplace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return RootNav();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}


class RootNav extends StatefulWidget { 
  @override 
  _RootNavState createState() => _RootNavState(); 
}
class _RootNavState extends State<RootNav> {
  int _current = 0;
  List<Map<String, dynamic>> cart = [];
  List<List<Map<String, dynamic>>> orders = [];
  
  @override
  Widget build(BuildContext ctx) {
    final pages = [
      HomePage(
        title: "Marketplace",
        addToCart: (product) {
          setState(() => cart.add(product));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added to cart!')),
          );
        },
      ),
      CheckoutPage(
        cart: cart,
        title: "Checkout",
        onPlaceOrder: (items) {
          setState(() {
            orders.add(List.from(items));
            cart.clear();
          });
        },
        onClearCart: () {
          setState(() => cart.clear());
        },
      ),
      OrdersPage(
        title: "Orders",
        orders: orders,
      ),
      ProfilePage(),
    ];

    return Scaffold(
      body: pages[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (i) => setState(() => _current = i),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "You"),
        ],
      ),
    );
  }
}