
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Role.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/screen/take_picture_screen.dart';
import 'package:image_picker/image_picker.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  _registerUserScreenState createState() =>_registerUserScreenState();
}

class _registerUserScreenState extends State<RegisterUserScreen> {
  bool _showLoader = false;
  bool _passwordShow = false;
  bool _photoChanged = false;
  bool _showSpecialty = false;
  late XFile _image;

   String _countryName = 'Iraq (Iq)';
  String _countryCode = '964';

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

  int _roleId = 0;
  String _roleIdError = '';
  bool _roleIdShowError = false;
  List<Role> _roles = [];

   String _role = '';
  String _roleError = '';
  bool _roleShowError = false;
  TextEditingController _roleController = TextEditingController();

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;
  TextEditingController _passwordController = TextEditingController();

  String _confirm = '';
  String _confirmError = '';
  bool _confirmShowError = false;
  TextEditingController _confirmController = TextEditingController();

  String _specialty = '';
  String _specialtyError = '';
  bool _specialtyShowError = false;
  TextEditingController _specialtyController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _roles.add(new Role(id: 1, Name: "Doctor"));
   _roles.add(new Role(id: 2, Name: "Patient"));  
  }
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('New User' ),
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
              _showRolesId(),  
              _showSpecialty?  _showspecialty():Container(),            
              _showPassword(),
              _showConfirm(),          
              _showButtons(),
            ],
          ),
        ),
          _showLoader ? LoaderComponent(text: 'Loading...',) : Container(), 
      ],
      ),
    );     
  }
  
 Widget _showPhoto() {
  return Stack(
    children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 10),
        child: !_photoChanged
            ? Image(
                image: AssetImage('assets/noimage.png'),
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(80),
                  child: Image.file(
                  File(_image.path),
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                )),
      ),
      Positioned(
        bottom: 0,
          left: 100,
          child: InkWell(
            onTap: () => _takePicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: Icon(
                  Icons.photo_camera,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ),
        Positioned(
           bottom: 0,
          left: 0,
          child: InkWell(
            onTap: () => _selectPicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
          )
          ),
    ],
  );
 }
 
 void _takePicture() async{
   WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var camera = cameras.first;
    var responseCamera = await showAlertDialog(
        context: context,
        title: 'select camera',
        message: 'What camera do you want to use?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'front', label: 'front'),
          AlertDialogAction(key: 'back', label: 'back'),
          AlertDialogAction(key: 'cancel', label: 'cancel'),
        ]);

    if (responseCamera == 'cancel') {
      return;
    }

    if (responseCamera == 'back') {
      camera = cameras.first;
    }

    if (responseCamera == 'front') {
      camera = cameras.last;
    }

    Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: camera)));
    if (response != null) {
      setState(() {
        _photoChanged = true;
        _image = response.result;
      });
    }
 }
  
 void _selectPicture() async{
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
      });
    }
 }
 
 Widget _showfirstName() {
  return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _firsNameController,
        decoration: InputDecoration(
          hintText: 'Enter names...',
          labelText: 'Names',
          errorText: _firsNameShowError? _firsNameError : null,
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
         _firsName = value;
        },
      ),
    );
 }
 
 Widget _showlastName() {
   return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
          hintText: 'Enter last name...',
          labelText: 'last name',
          errorText: _lastNameShowError ? _lastNameError : null,
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
 } 
 
  
  Widget _showRolesId() {
     return Container(
        padding: EdgeInsets.all(10),
        child: _roles.length == 0
            ? Text('Loading roles...')
            : DropdownButtonFormField(
                items: _getComboRoles(),
                value: _roleId,
                onChanged: (option) {
                  setState(() {
                    _roleId = option as int;
                     if ( _roleId == 1) {
                      _showSpecialty = true;
                    } else {
                      _showSpecialty = false;
                      _specialty = "General";
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select a role...',
                  labelText: 'Role',
                  errorText:
                     _roleIdShowError ? _roleIdError : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ));
  }
  
  List<DropdownMenuItem<int>>  _getComboRoles() {
     List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Select a role...'),
      value: 0,
    ));   
    _roles.forEach((documnentType) {
      list.add(DropdownMenuItem(
        child: Text(documnentType.Name),
        value: documnentType.id,
        
      ));
      
    });
    return list;
  }
   _showEmail() {
    return Container(
       padding: EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'insert you email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
   }
  _showAddress() {
     return Container(
       padding: EdgeInsets.all(10),
      child: TextField(
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          hintText: 'Enter address..',
          labelText: 'Address',
          errorText: _addressShowError ? _addressError : null,
          suffixIcon: Icon(Icons.home),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _address = value;
        },
      ),
    );
  }
  
  _showPhoneNumber() {
     return Container(
       padding: EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Enter phone...',
          labelText: 'telephone',
          errorText: _phoneNumberShowError ? _phoneNumberError : null,
          suffixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }
  
  _showPassword() {
     return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Enter a password...',
          labelText: 'Password',
          errorText: _passwordShowError ? _passwordError : null,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }
  
  _showConfirm() {
     return Container(
       padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Enter a password confirmation...',
          labelText: 'password confirmation',
          errorText: _confirmShowError ? _confirmError : null,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _confirm = value;
        },
      ),
    );
  }
  
  _showButtons() {
     return Container(
       margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showRegisterButton(),
        ],
      ),
    );
  }
  
 Widget _showRegisterButton() {
  return Expanded(
    child: ElevatedButton(
        child: Text('Register'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Color(0xFF120E43);
          }),
        ),
        onPressed: () => _register(),
      ),
  );
 }
 
 void _register() async{
   if (!_validateFields()) {
      return;
    }
     _addRecord();
 }
 
  bool _validateFields() {
    bool isValid = true;

    if (_firsName.isEmpty) {
      isValid = false;
     _firsNameShowError = true;
    _firsNameError = 'You must enter at least one name.';
    } else {
     _firsNameShowError= false;
    }

    if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'You must enter at least one last name.';
    } else {
      _lastNameShowError = false;
    }

    if (_roleId == 0) {
      isValid = false;
      _roleIdShowError = true;
      _roleError = 'You must select a Role.';
    } else {
     _roleIdShowError = false;
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

    if (_password.length < 6) {
      isValid = false;
      _passwordShowError = true;
      _passwordError =
          'You must enter a password of at least 6 characters.';
    } else {
      _passwordShowError = false;
    }

    if (_confirm.length < 6) {
      isValid = false;
      _confirmShowError = true;
      _confirmError =
          'You must enter a password confirmation of at least 6 characters.';
    } else {
      _confirmShowError = false;
    }

    if (_confirm != _password) {
      isValid = false;
      _confirmShowError = true;
      _confirmError = 'The password and confirmation are not the same.';
    } else {
      _confirmShowError = false;
    }
     if (_specialty.isEmpty) {
      isValid = false;
      _specialtyShowError = true;
     _specialtyError = 'You must enter a phone.';
    } else {
      _specialtyShowError = false;
    }

    setState(() {});
    return isValid;
  }
  
  void _addRecord() async{
     setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Check your internet connection.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
          ]);
      return;
    }

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': _firsName,
      'lastName': _lastName,
      'roleId': _roleId,     
      'email': _email,      
      'address': _address,   
      'countryCode': _countryCode,  
      'phoneNumber': _phoneNumber,
      'image': base64image,
      'password': _password,
      'specialty':_specialty,
    };

    Response response = await Apihelper.PostnoToken(
      '/api/Account/',
      request,
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
          ]);
      return;
    }

    await showAlertDialog(
        context: context,
        title: 'Confirmation',
        message:
            'An email has been sent with the instructions to activate the user. Please activate it to be able to enter the application.',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Accept'),
        ]);

    Navigator.pop(context, 'yes');
  }
  
 Widget _showCountry() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: <Widget>[
        ElevatedButton(
          child:Text("Country code"),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState>States){
            return Color(0xFFE03B8B);
          }),
          ),
          onPressed: ()=> _selectCountry(),      
        ),
        SizedBox(width: 10,),
        Text('$_countryCode $_countryName')
      ],
    ),
  );
 }
 
 void _selectCountry() {
  showCountryPicker(
    context: context,
     onSelect: ((Country country){
      setState(() {
        _countryName=country.displayNameNoCountryCode;
        _countryCode=country.phoneCode;
      });
     })
     );
 }
 
 Widget _showspecialty() {
  return Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    controller: _specialtyController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'enter Specialty...',
                                      labelText: 'Specialty',
                                      errorText: _specialtyShowError ?_specialtyError : null,
                                      suffixIcon: Icon(Icons.document_scanner),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                    onChanged: (value) {
                                     _specialty = value;
                                    },
                                  ),
              );
 }
   
  

}