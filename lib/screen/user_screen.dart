
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/screen/take_picture_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../components/loader_component.dart';
import '../models/token.dart';
import '../models/user.dart';

class UserScreen extends StatefulWidget {
final Token token;
  final User user;
  
  UserScreen({required this.token , required this.user});

  @override
 _userScreen createState() => _userScreen();
}

class _userScreen extends State<UserScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;
  String _firsName = '';
  String _firsNameError = '';
  bool _firsNameShowError = false;
  TextEditingController _firsNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  TextEditingController _lastNameController = TextEditingController();

  String _address = '';
  String _addressError = '';
  bool _addressShowError = false;
  TextEditingController _addressController = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  TextEditingController _phoneNumberController = TextEditingController();
  

  @override
  void initState() {
    // TODO: implement initState    
     _firsName = widget.user.firstName;
   _firsNameController.text = _firsName; 

   _lastName=widget.user.lastName ;
   _lastNameController.text=_lastName;

   _address=widget.user.address;
   _addressController.text=_address;

   _email=widget.user.email;
   _emailController.text=_email;

   _phoneNumber=widget.user.phoneNumber;
   _phoneNumberController.text=_phoneNumber;

  }
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.id.isEmpty
            ? 'New User' 
            : widget.user.fullName
        ),
      ),
      body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showPhoto(), 
              _showfirstName(), 
              _showlastName(),  
              _showEmail(),
              _showAddress(),
              _showCountry(),
              _showPhoneNumber(),          
              _showButtons(),
            ],
          ),
        ),
          _showLoader ? LoaderComponent(text: 'Loading...',) : Container(), 
      ],
      ),
    );     
  }
  
 Widget _showfirstName() {
     return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller:_firsNameController,
        decoration: InputDecoration(
          hintText: 'Enter a first name......',
          labelText: 'First Name',
          errorText: _firsNameShowError ? _firsNameError : null,
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _firsName = value;
        },
      ),
    );
  }
  
 Widget _showButtons() {
     return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Save'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF120E43);
                  }
                ),
              ),
              onPressed: () => _save(), 
            ),
          ),
          widget.user.id.isEmpty
            ? Container() 
            : SizedBox(width: 20,),
          widget.user.id.isEmpty
            ? Container() 
            : Expanded(
                child: ElevatedButton(
                  child: Text('Delete'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Color(0xFFB4161B);
                      }
                    ),
                  ),
                  onPressed: () => _confirmDelete(), 
              ),
          ),
        ],
      ),
    );
  }
  
void  _save() {
     if (!_validateFields()) {
      return;
    }

    widget.user.id .isEmpty ? _addRecord() : _saveRecord();
  }
  
  bool _validateFields() {
     bool isValid = true;
    if (_firsName.isEmpty) {
      isValid = false;
     _firsNameShowError = true;
     _firsNameError = 'You must enter a first name..';
    } else {
     _firsNameShowError = false;
    }  
     if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'You must enter at least one last name.';
    } else {
      _lastNameShowError = false;
    }
    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'You must enter an email.';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'You must enter a valid email.';
    } else {
      _emailShowError = false;
    }
    if (_address.isEmpty) {
      isValid = false;
      _addressShowError = true;
      _addressError = 'You must enter an address.';
    } else {
      _addressShowError = false;
    }

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'You must enter a phone.';
    } else {
      _phoneNumberShowError = false;
    }
    setState(() { });
    return isValid;
  }
  
 void _addRecord() async{

 setState(() {
      _showLoader = true;
    });

    String base64image ='';
    if(_photoChanged)
    {
      List<int> imageBytes=await _image.readAsBytes();
      base64image=base64Encode(imageBytes);
    }
     var connectivityResult= await Connectivity().checkConnectivity();
  
  if(connectivityResult == ConnectivityResult.none )
  {
    setState(() {
  _showLoader=false;
  });
    await showAlertDialog(
      context: context, 
      title:'Error',  
      message: 'check your internet connection.',    
     actions: <AlertDialogAction>[
      AlertDialogAction(key: null, label:'Accept')
     ]
         );
      return ;
      
  }
    Map<String, dynamic> request = {    
      'firstname': _firsName,  
       'lastName': _lastName,
       'firstname': _firsName,
       'email':     _email,
       'userName': _email,
       'address': _address,   
       'phoneNumber': _phoneNumber,  
       'image':base64image,    
    };

    Response response;
    response = await Apihelper.Post(
      '/api/Users/', 
      request, 
      widget.token,
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Navigator.pop(context, 'yes'); 
     }
    
     void _saveRecord() async{
      setState(() {
      _showLoader = true;
    });
      String base64image ='';
    if(_photoChanged)
    {
      List<int> imageBytes=await _image.readAsBytes();
      base64image=base64Encode(imageBytes);
    }
     var connectivityResult= await Connectivity().checkConnectivity();
 
  if(connectivityResult == ConnectivityResult.none )
  {
     setState(() {
   _showLoader=false;
  });
    await showAlertDialog(
      context: context, 
      title:'Error',  
      message: 'check your internet connection.',    
     actions: <AlertDialogAction>[
      AlertDialogAction(key: null, label:'Accept')
     ]
         );
      return ;
      
  }
     Map<String, dynamic> request = {
      'id': widget.user.id,
      'firstname': _firsName,
      'lastName': _lastName,
      'firstname': _firsName,
      'email':     _email,
      'userName': _email,
      'address': _address,   
      'phoneNumber': _phoneNumber,   
      'image':base64image, 
    };

    Response response = await Apihelper.Put(
      '/api/users/', 
      widget.user.id, 
      request, 
      widget.token
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Navigator.pop(context, 'yes');
     }
     
     void  _confirmDelete() async{
       var response =  await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Are you sure you want to delete the record?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'yes'),
      ]
    );    

    if (response == 'yes') {
      _deleteRecord();
    }
     }
     
       void _deleteRecord() async{
         setState(() {
      _showLoader = true;
    });
     var connectivityResult= await Connectivity().checkConnectivity();  
  if(connectivityResult == ConnectivityResult.none )
  {
    setState(() {
  _showLoader=false;
  });
    await showAlertDialog(
      context: context, 
      title:'Error',  
      message: 'check your internet connection.',    
     actions: <AlertDialogAction>[
      AlertDialogAction(key: null, label:'Accept')
     ]
         );
      return ;
      
  }
     Response response = await Apihelper.Delete(
      '/api/Users/', 
      widget.user.id, 
      widget.token
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Navigator.pop(context, 'yes');
       }
       
        Widget _showPhoto() {
          return  Stack(
            children:<Widget>[
               Container(
              margin: EdgeInsets.only(top: 10),
              child:widget.user.id.isEmpty && !_photoChanged ? Image
                    (
                      image: AssetImage('assets/noimage.png'),           
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                        ): ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:_photoChanged ? 
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
                                  image: AssetImage('assets/noimage.png'),
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
        
        Widget _showlastName() {
             return Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller:_lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter a last name......',
                      labelText: 'Last Name',
                      errorText: _lastNameShowError ? _lastNameError : null,
                      suffixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    onChanged: (value) {
                      _lastName = value;
                    },
                  ),
    );
          }
          
           Widget _showEmail() {
               return Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  enabled: widget.user.id.isEmpty,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'enter email...',
                                    labelText: 'Email',
                                    errorText: _emailShowError ? _emailError : null,
                                    suffixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                  onChanged: (value) {
                                    _email = value;
                                  },
                                ),
                              );
           }
           
           Widget  _showAddress() {
            return Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: _addressController,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                hintText: 'enter address...',
                                labelText: 'Address',
                                errorText: _addressShowError ? _addressError : null,
                                suffixIcon: Icon(Icons.home),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                              onChanged: (value) {
                                _address = value;
                              },
                            ),
        );
           }
           
          Widget   _showCountry() {
            return Container();
          }
          
           Widget _showPhoneNumber() {
            return Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'enter telephone ...',
                          labelText: 'Telephone',
                          errorText: _phoneNumberShowError ? _phoneNumberError : null,
                          suffixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        onChanged: (value) {
                          _phoneNumber = value;
                        },
                      ),
    );
           }
           
            void  _Takepicture() async{
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
                  _photoChanged=true;
                  _image=response.result;
                });
              }
            }
            
             void _selectPicture() async{
              final ImagePicker _picker= ImagePicker();
              final XFile? image= await _picker.pickImage(source: ImageSource.gallery);
              if(image !=null)
              {
                setState(() {
                  _photoChanged=true;
                _image=image;                  
                });                
              }
             }
}