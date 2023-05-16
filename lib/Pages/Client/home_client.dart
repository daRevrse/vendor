import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Pages/Client/product_list.dart';
import 'package:vendor/Pages/Common/chat_page.dart';
import 'package:vendor/Pages/Common/chat_rooms.dart';

import '../../Models/users.dart';

class HomeClient extends StatefulWidget {
  final Users user;

  const HomeClient({super.key, required this.user});
  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  int _selectedIndex = 0;

  var chatRoomId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString('CHATROOMID') ?? "";

    setState(() {
      chatRoomId = stringValue;
    });
  }

  @override
  initState() {
    getStringValuesSF();

    print(chatRoomId);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        // Home Page
        ProductList(user: widget.user,),
        // Chats Page
        chatRoomId == "" ? Container() : Chat(chatRoomId: chatRoomId, user: widget.user,),
        // Profile Page
        Container(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
