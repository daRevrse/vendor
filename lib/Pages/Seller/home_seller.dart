import 'package:flutter/material.dart';
import 'package:vendor/Pages/Common/chat_page.dart';
import 'package:vendor/Pages/Common/chat_rooms.dart';
import 'package:vendor/Pages/Seller/product_manager.dart';

import '../../Models/users.dart';

class HomeSeller extends StatefulWidget {
  final Users user;

  const HomeSeller({super.key, required this.user});
  @override
  _HomeSellerState createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        // Home Page
        ProductManager(user: widget.user,),
        // Chats Page
        ChatRoom(user: widget.user,),
        // Profile Page
        Container(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
