import 'package:be_project/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'AddImage.dart';
import 'customisedDataset.dart';

class AddWord extends StatefulWidget {
  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  TextEditingController gestureNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Customised DataSet", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              ),
              SizedBox(
                  height: 60.0),
              TextFormField(
                controller: gestureNameController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Enter gesture name..",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),

                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                  onPressed: (){
                    Map <String, dynamic> data = {"gestureName": gestureNameController.text};
                    FirebaseFirestore.instance.collection("test").add(data);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                            new AddImage(gestureNameController.text)));

                  },
                  child: Text("Submit"),
                color: Colors.blueAccent,
              )
            ],
          ),
        ),
      ),

    );
  }
}
