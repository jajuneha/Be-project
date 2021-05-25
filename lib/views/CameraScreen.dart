import 'package:be_project/views/CameraView.dart';
import 'package:be_project/views/VideoView.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  CameraController _cameraController;
  Future<void> cameraValue;
  bool isRecording = false;
  String videopath = "";


  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                          }),

                      GestureDetector(
                        onLongPress: () async {
                          final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.mp4");
                          await _cameraController.startVideoRecording(path);
                          setState(() {
                            isRecording = true;
                            videopath = path;
                          });
                        },
                        onLongPressUp: () async {
                          await _cameraController.stopVideoRecording();
                          setState(() {
                            isRecording = false;

                          });
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => VideoViewPage(path: videopath)));
                        },
                        onTap: (){
                          if(!isRecording)
                          takePhoto(context);
                        },
                        child: isRecording? Icon(Icons.radio_button_on, color: Colors.red,size: 80,): Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,

                          ),
                          onPressed: (){}),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Hold for Video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void takePhoto(BuildContext context) async {
    final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    await _cameraController.takePicture(path);
    Navigator.push(context, MaterialPageRoute(builder: (builder) => CameraViewPage(path: path)));
  }

}