import 'package:be_project/helper/authenticate.dart';
import 'package:be_project/helper/helperfunctions.dart';
import 'package:be_project/views/AddWord.dart';
import 'package:be_project/views/CameraPage.dart';
import 'package:be_project/views/CameraScreen.dart';
import 'package:be_project/views/chatRoomsScreen.dart';
import 'package:be_project/views/customisedDataset.dart';
import 'package:be_project/views/signin.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


//List<CameraDescription> cameras;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BE Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      home:
      userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
          : Container(
        child: Center(
        child: Authenticate(),
    ),
      ),
     // userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}
