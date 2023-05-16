import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:vendor/Models/produit.dart';
import 'dart:io';

import 'package:vendor/Services/database.dart';

import '../../Models/users.dart';
import '../../Widgets/product_card.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProductManager extends StatefulWidget {
  final Users user;

  const ProductManager({super.key, required this.user});

  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  final _formKey = GlobalKey<FormState>();

  var name,description,imageUrl;
  late double price;
  var _imageFile;

  String generateProductId() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  Future<String> uploadImage(ImageSource imageFile ) async {
    String _imageUrl = "";
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }

    String fileName = basename(_imageFile.path);
    String folderName = generateProductId();

    Reference ref = FirebaseStorage.instance.ref().child('images/$folderName/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile);

    var dowurl = await (await uploadTask).ref.getDownloadURL();
    _imageUrl = dowurl.toString();

    imageUrl = _imageUrl;

    return _imageUrl;
  }

  // Fonction pour afficher un dialog pour sélectionner la source de l'image (galerie ou caméra)
  Future<void> _showPickImageDialog() async {
    return showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir une image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Galerie'),
                  onTap: () {
                    setState(() {
                      imageUrl = uploadImage(ImageSource.gallery).toString();
                    });
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Caméra'),
                  onTap: () {
                    setState(() {
                      imageUrl = uploadImage(ImageSource.camera).toString();
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: StreamBuilder<QuerySnapshot>(
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
                        crossAxisCount: 3,
                        children: productCards,
                      );
                    },
                  )
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 1/4,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                right: -40.0,
                                top: -40.0,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.close),
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "Product Name"),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter the name";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => name = value!,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        //maxLines: 5,
                                        decoration: InputDecoration(
                                            labelText: "Product Description"),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter the description";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => description = value!,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration:
                                        InputDecoration(labelText: "Product Price"),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter the price";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => price = double.parse(value!),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 100.0,
                                            child: Text('Image :'),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: _showPickImageDialog,
                                              child: _imageFile == null
                                                  ? Text('Sélectionner une image')
                                                  : Image.file(_imageFile,scale: 0.1,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        child: Text("Submit"),
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            _formKey.currentState!.save();
                                            Product product = Product(id: generateProductId(), name: name, description: description, imageUrl: imageUrl, price: price,ownerUid: widget.user.uid);
                                            DBOperations().addProduct(product);

                                            print(imageUrl);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text("Add a Product"),
              ),
            )
          ],
        ),
      ),
    );
  }
}