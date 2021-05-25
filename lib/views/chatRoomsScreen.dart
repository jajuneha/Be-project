import 'package:be_project/helper/authenticate.dart';
import 'package:be_project/helper/constants.dart';
import 'package:be_project/helper/helperfunctions.dart';
import 'package:be_project/services/auth.dart';
import 'package:be_project/services/database.dart';
import 'package:be_project/views/AddWord.dart';
import 'package:be_project/views/conversation_screen.dart';
import 'package:be_project/views/search.dart';
import 'package:be_project/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with SingleTickerProviderStateMixin{
  TabController _controller;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomTile(
                userName: snapshot.data.docs[index].data()["chatroomId"].toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.docs [index].data()["chatroomId"],
              );
            })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }
  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     // title: Image.asset("assets/images/logo.png", height: 50,),
        title: Text("BE-PROJECT"),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              text: "Chats",
            ),
            Tab(
              text: "Customised Gestures",
            ),
          ],
        ),

      ),

      body: TabBarView(
        controller: _controller,
        children: [
          chatRoomsList(),
          AddWord(),
        ],
      ),
      //chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
              child: Text("${userName.substring(0, 1).toUpperCase()}",
                  style: mediumTextStyle(),),
            ),
            SizedBox(width: 8,),
            Text(userName,
                style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
