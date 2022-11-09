import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/take_picture_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../components/loader_component.dart';
import '../models/user.dart';

class PatientScreen extends StatefulWidget {
  final Token token;
  final User user;
  final Patients patient;
 PatientScreen({required this.token ,required this.user, required this.patient});

  @override
  _patientScreenState createState() => _patientScreenState();
}

class _patientScreenState extends State<PatientScreen> {
  bool _showLoader=false;
  bool _photochanged=false;
  late XFile _image;
  int _current=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.patient.id==0 ? 'Add Patient' : '${widget.patient.fullName}'
        ),
      ),
      body: Stack(
        children: [
         SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showCity(),
              _showBloodType(),
              _showGendre(),
              _shownationality(),
              _showUserPatient(),
              _showPatientPhoto(),
              _showDate(),
              _showfirstName(),
              _showLastName(),
              _showDescription(),
              _showAdress(),
              _showEpcNumber(),
              _showmobileNumber(),
              _showButtons(),
            ],
          ),
         ),
         _showLoader ? LoaderComponent(text: 'Loading...',) : Container(),
        ],
      ),
    );
  }
  
 Widget _showCity() {
   return Container(

  );
 }
  
 Widget _showBloodType() {
   return Container(

  );
 }
  
 Widget _showGendre() {
   return Container(

  );
 }
 Widget _shownationality() {
   return Container(

  );
 }
  
 Widget _showUserPatient() {
   return Container(

  );
 }
  
 Widget _showPatientPhoto() {
    return  Stack(
            children:<Widget>[
               Container(
              margin: EdgeInsets.only(top: 10),
              child:widget.patient.id==0 && !_photochanged ? Image
                    (
                      image: AssetImage('assets/noimage.png'),           
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                        ): ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:_photochanged ? 
                            Image.file(
                             File(_image.path),
                             height: 160,
                             width: 160,
                             fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                                imageUrl: widget.user.imageFullPath,
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                                height: 160,
                                width: 160,
                                placeholder: (context, url) => Image(
                                  image: AssetImage('assets/vehicles_logo.png'),
                                  fit: BoxFit.cover,
                                  height: 160,
                                  width: 160,
                    ),
                       
                          ),
                           ),
            ),
             Positioned(
              bottom: 0,
              left: 100,
              child: InkWell(
                onTap: ()=>_Takepicture(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.green[50],
                    height: 60,
                    width: 60,
                    child: Icon(Icons.photo_camera, size: 40, color: Colors.blue,),
                  ),
                ),
              ),
              ),
              
            Positioned(
              bottom: 0,
              left: 0,
              child:InkWell(
                onTap: ()=> _selectPicture(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.green[50],
                    height: 60,
                    width: 60,
                    child: Icon(Icons.image, size: 40, color: Colors.blue,),
                  ),
                ),
              ),
              ),
              
            ]
          );
  
 }
  
 Widget _showDate() {
  return Container(

  );
 }
  
Widget  _showfirstName() {
   return Container(

  );
}
  
Widget  _showLastName() {
   return Container(

  );
}
  
Widget  _showDescription() {
   return Container(

  );
}
  
Widget  _showAdress() {
   return Container(

  );
}
  
Widget  _showEpcNumber() {
   return Container(

  );
}
  
Widget  _showmobileNumber() {
   return Container(

  );
}
  
Widget  _showButtons() {
   return Container(

  );
}

  void _Takepicture() async{
      WidgetsFlutterBinding.ensureInitialized();
              final camera= await availableCameras();
              final firstcamera=camera.first;
            Response? response= await  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePictureScreen(camera:firstcamera,),
              ),
              );
              if(response !=null)
              {
                setState(() {
                 _photochanged=true;
                  _image=response.result;
                });
              }    
  }
  
 void _selectPicture()async {
  final ImagePicker _picker= ImagePicker();
              final XFile? image= await _picker.pickImage(source: ImageSource.gallery);
              if(image !=null)
              {
                setState(() {
                  _photochanged=true;
                _image=image;                  
                });                
              }
 }
  
  
}