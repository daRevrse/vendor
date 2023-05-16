import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor/Models/users.dart';

import '../Models/produit.dart';
import '../Pages/Client/home_client.dart';
import '../Pages/Seller/home_seller.dart';

class DBOperations {

  storeNewUser(Users _user, UserCredential user, context) async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .set({'email': _user.email, 'uid': user.user!.uid, 'type': _user.type, 'name': _user.name})
          .then((value) => {})
          .catchError((e) {
        print(e);
      });
    }
  }

  getUserType(context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
            var _user = Users.fromMap(value.data());
        var userType = value.data()!['type'];
        if (userType == "client") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeClient(user: _user,)));
        }
        else if (userType == "vendeur") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeSeller(user: _user,)));
        }
      });
    }
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  searchByUid(String searchField) {

    //late Users user;
    FirebaseFirestore.instance
        .collection("users")
        .doc(searchField)
        .get();
    //return user;
  }

  searchChatRoom(String searchField) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('chatRoomId', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData)async {

    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  Future<void> addProduct(Product product) {
    return FirebaseFirestore.instance
        .collection('products')
        .add(product.toMap())
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add product: $error"));
  }

  Future<void> updateProduct(String id, Product product) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .set(product.toMap())
        .then((value) => print("Product Updated"))
        .catchError((error) => print("Failed to update product: $error"));
  }

  Future<void> deleteProduct(String id) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .delete()
        .then((value) => print("Product Deleted"))
        .catchError((error) => print("Failed to delete product: $error"));
  }


}