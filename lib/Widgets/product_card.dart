import 'package:flutter/material.dart';

import '../Models/produit.dart';
import '../Models/users.dart';
import '../Pages/Client/product_details.dart';

class ProductCard extends StatelessWidget {
  final Users user;

  final Product product;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  ProductCard({required this.name, required this.price, required this.imageUrl, required this.description, required this.product, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Image.network(imageUrl,fit: BoxFit.cover,)),
            Text(name),
            Text(description),
            Text('Price: \$$price'),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(product: product, user: user,),
          ),
        );
      },
    );
  }
}