import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Pages/Common/chat_page.dart';
import 'package:vendor/Services/database.dart';

import '../../Models/produit.dart';
import '../../Models/users.dart';

class ProductDetails extends StatefulWidget {
  final Users user;
  final Product product;
  const ProductDetails({Key? key, required this.user, required this.product}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  String chatRoomId = "";
  String receiver = "";

  getChatRoomIdSharedPreference(String source) async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    var x = preferences.getString("CHATROOMID").toString();

    setState(() {
      source = x;
    });

  }

  static Future<bool> saveChatRoomIdSharedPreference(String id) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("CHATROOMID", id);
  }

   generateChatRoomId() async {

     //var _receiver;

     FirebaseFirestore.instance
         .collection("users")
         .doc(widget.product.ownerUid.toString())
         .get().then((value) {
       var _receiver = Users.fromMap(value.data());

       String sender;

       sender = widget.user.name;
       if (sender.substring(0, 1).codeUnitAt(0) >
           _receiver.name.substring(0, 1).codeUnitAt(0)) {
         setState(() {
           receiver = _receiver.name;

           chatRoomId = "${receiver}_$sender";
         });
       } else {
         setState(() {
           receiver = _receiver.name;

           chatRoomId = "${sender}_$receiver";
         });

         List<String> users = [widget.user.name,receiver];

         Map<String, dynamic> chatRoom = {
           "users": users,
           "chatRoomId" : chatRoomId,
         };

         DBOperations().addChatRoom(chatRoom, chatRoomId);
         saveChatRoomIdSharedPreference(chatRoomId);

         addMessage();

         Navigator.push(context, MaterialPageRoute(
             builder: (context) => Chat(
               chatRoomId: chatRoomId, user: widget.user,
             )
         ));

         print(chatRoom);

         print(receiver);
         print(widget.product.ownerUid.toString());
       }
     });

    }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ImageSlideshow(
          indicatorColor: Colors.blue,
          onPageChanged: (value) {},
          autoPlayInterval: 3000,
          isLoop: true,
          children: [
            Image.network(widget.product.imageUrl),
            Image.network(widget.product.imageUrl),
            Image.network(widget.product.imageUrl),
          ],
        ),
            //Image.network(widget.product.imageUrl),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: \$${widget.product.price}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: (){

              getChatRoomIdSharedPreference(chatRoomId);

              if(chatRoomId == ""){
                generateChatRoomId();
              }
                //addMessage();
            },
                child: const Text("Chat")
            )
          ],
        ),
      ),
    );
  }

  addMessage() {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": widget.user.name,
      "message": "Let's talk about this : ${widget.product.name}",
      'time': DateTime
          .now()
          .millisecondsSinceEpoch,
    };

    print(chatMessageMap);

    DBOperations().addMessage(chatRoomId, chatMessageMap);

  }
}