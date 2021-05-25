import 'package:be_project/helper/constants.dart';
import 'package:be_project/services/database.dart';
import 'package:be_project/views/detectScreen.dart';
import 'package:be_project/widgets/widget.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'CameraPage.dart';
import 'SpeechText.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  bool show = false;
  FocusNode focusNode = FocusNode();
  //TextEditingController _controller = TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  SpeechToText stt = SpeechToText();
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
            return MessageTile(snapshot.data.docs[index].data()["message"],
                snapshot.data.docs[index].data()["sendBy"] == Constants.myName);
            }) : Container();
      },
    );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessage(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    focusNode.addListener(() {
      if(focusNode.hasFocus)
        {
          setState(() {
            show = false;
          });
        }
    });


    super.initState();
    initializeAudio();
  }
  initializeAudio() async {
    stt.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    Icons.arrow_back,
                size: 24,
                ),
                CircleAvatar(
                  radius: 20,
                    backgroundColor: Colors.blueGrey,
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: (){},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Neha", style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Text("last seen today at 4:05", style: TextStyle(
                    fontSize: 13,
                  ),),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(icon: Icon(Icons.videocam), onPressed: (){}),
            IconButton(icon: Icon(Icons.call), onPressed: (){}),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,

        child: WillPopScope(
          child: Stack(
            children: [
              ChatMessageList(),
              Align(
                alignment: Alignment.bottomCenter,
                /*alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),*/

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Card(
                                margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextFormField(
                                  focusNode: focusNode,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  controller: messageController,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Message...",
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.emoji_emotions,
                                      ),
                                      onPressed: (){
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                        setState(() {
                                          show = !show;
                                        });
                                      },
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(icon: Icon(Icons.camera_alt),
                                            onPressed: (){
                                          print("A");
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetectScreen()),);

                                            },
                                        )
                                      ],
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                              right: 5,
                              left: 2,
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xff145C9E),
                              child: IconButton(

                                icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                                color: Colors.white,),
                                onPressed: (){
                                  _listen();
                                 //  Navigator.push(
                                 //      context,
                                 //      new MaterialPageRoute(
                                 //          builder: (BuildContext context) =>
                                 //          new SpeechScreen(_text)));
                                },
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: (){
                          //     sendMessage();
                          //   },
                          //   child: Container(
                          //       height: 40,
                          //       width: 40,
                          //       decoration: BoxDecoration(
                          //           gradient: LinearGradient(
                          //             colors: [
                          //               const Color(0x36FFFFFF),
                          //               const Color(0x0FFFFFFF)
                          //             ],
                          //           ),
                          //           borderRadius: BorderRadius.circular(40)
                          //       ),
                          //       padding: EdgeInsets.all(12),
                          //       child: Image.asset("assets/images/send.png")),
                          // )
                        ],
                      ),
                      show? emojiSelect() : Container(),
                    ],
                  ),
                ),
              ],
          ),
          onWillPop: (){
            if(show)
              {
                setState(() {
                  show = false;
                });
              }
            else
              {
                Navigator.pop(context);
              }
            return Future.value(false);
          },
        ),
      ),
    );
  }
  Widget emojiSelect() {
    return EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          print(emoji);
          setState(() {
            messageController.text = messageController.text + emoji.emoji;
          });
        });
  }
  void _listen() async {
    if(stt.isAvailable)
    {
      if(!_isListening)
      {
        stt.listen(
            onResult: (result){
              setState(() {
                _text = result.recognizedWords;
                _isListening = true;
              });
            });

      }
      else{
        setState(() {
          _isListening = false;
          stt.stop();
        });
      }
    }else{
      print("permission denied");
    }
  }
}



class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24, right : isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            ),
          borderRadius: isSendByMe ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
        ),
        child: Text(message, style: TextStyle(
            color: Colors.white,
            fontSize: 17
        ),),
      ),
    );
  }
}

