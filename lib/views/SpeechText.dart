import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';


class SpeechScreen extends StatefulWidget {
  String text;
  SpeechScreen(this.text);
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  SpeechToText stt = SpeechToText();

  bool _isListening = false;
//  String _text = '';
  double _confidence = 1.0;

  @override
  void initState() {
    widget.text = '';
    super.initState();
    initializeAudio();
  }
  initializeAudio() async {
    stt.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpeechToText'),
        centerTitle: true,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 32.0,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if(stt.isAvailable)
      {
        if(!_isListening)
          {
            stt.listen(
              onResult: (result){
                setState(() {
                  widget.text = result.recognizedWords;
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


