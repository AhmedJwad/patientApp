import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/screen/display_picture_screen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

TakePictureScreen({required this.camera});
  @override
  _takePictureScreen createState() => _takePictureScreen();
}

class _takePictureScreen extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void>_initializeControllerFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=CameraController(widget.camera,ResolutionPreset.low);
    _initializeControllerFuture=_controller.initialize();
  }
  @override
  void dispose() {
        // TODO: implement dispose
    _controller.dispose() ;   
    super.dispose();    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text('Take photo'),),
     body: FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async{
        try {
          await _initializeControllerFuture;
          final image=await _controller.takePicture();
          Response? response =await Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> DisplayPictureScreen(image:image,))
            ) ;
            if (response != null) {
              Navigator.pop(context, response);
            }

        } catch (e) {
           print(e);
        }
        },
        ),     
    );
  }
}