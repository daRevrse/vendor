import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/Models/produit.dart';
import 'package:vendor/Pages/Client/product_details.dart';

import '../../Models/users.dart';
import '../../Widgets/product_card.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProductList extends StatefulWidget {
  final Users user;

  const ProductList({super.key, required this.user});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final products = snapshot.data!.docs;
        List<ProductCard> productCards = [];
        for (var product in products) {
          final name = product['name'].toString();
          final price =  product['price'];
          final imageUrl = product['imageUrl'].toString();
          final description = product['description'].toString();
          final productCard = ProductCard(
            name: name,
            price: price,
            imageUrl: imageUrl,
            description: description,
            product: Product.fromMap(product),
            user: widget.user,
          );
          productCards.add(productCard);
        }
        return GridView.count(
          crossAxisCount: 2,
          children: productCards,
        );
      },
    );
  }
}


