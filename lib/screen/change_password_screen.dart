import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';


class ChangePasswordScreen extends StatefulWidget {
  final Token token;

  ChangePasswordScreen({required this.token});

  @override
  _changePasswordScreenState createState() => _changePasswordScreenState();
}

class  _changePasswordScreenState extends State<ChangePasswordScreen> {
  bool _showLoader=false;
  bool _passwordShow=false;

  String _currentPassword='';
  String _currentPasswordError='';
  bool _currentPasswordShowError=false;
  TextEditingController _currentPasswordcontroller= TextEditingController();

  String _newPassword='';
  String _newPasswordError='';
  bool _newPasswordShowerror=false;
  TextEditingController _newPasswordcontroller= TextEditingController();

  String _confirmPassword='';
  String _confirmPasswordError='';
  bool _confirmPasswordshowError=false;
  TextEditingController _confirmPasswordcontroller= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("change Password"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
               _showCurrentPassword(),
                _showNewPassword(),
                _showConfirmPassword(),
                _showButtons(),
            ],
          ),
          _showLoader?LoaderComponent(text: "Loading...",):Container(),
        ],
      ),
    );
  }
  
 Widget _showCurrentPassword() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      obscureText: !_passwordShow,
      decoration: InputDecoration(
        hintText: 'Enter your current password..',
        labelText: 'Current password',
       errorText: _currentPasswordShowError ?_currentPasswordError:null,
       prefixIcon: Icon(Icons.lock),
       suffixIcon: IconButton(
        icon: _passwordShow ? Icon(Icons.visibility):Icon(Icons.visibility_off),
        onPressed: (){
          setState(() {
            _passwordShow = !_passwordShow;
          });
        },        
       ),
       border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
       ),
      ),
      onChanged: (value){
        _currentPassword=value;
      },
    ),
  );
 }
  
 Widget _showNewPassword() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
            obscureText:! _passwordShow,
            decoration: InputDecoration(
            hintText: "Enter a new password",
            labelText: "New Password",
            errorText: _newPasswordShowerror ? _newPasswordError:null,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
                        icon:_passwordShow ? Icon(Icons.visibility): Icon(Icons.visibility_off),
                        onPressed: (){
                            setState(() {
                              _passwordShow = !_passwordShow;             

                            });
                          },
            ), 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))       
          ),
          onChanged: (value){
            _newPassword=value;
          },
    ),
  );
 }
  
Widget  _showConfirmPassword() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      obscureText: !_passwordShow,
      decoration: InputDecoration(
        hintText: 'Enter confirm password',
        labelText: "Confirm Password",
        errorText: _confirmPasswordshowError ? _confirmPasswordError:null,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
           icon: _passwordShow ? Icon(Icons.visibility):Icon(Icons.visibility_off),
           onPressed: (){
            setState(() {
              _passwordShow= ! _passwordShow;
            });
           },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (value){
        _confirmPassword=value;
      },
    ),
  );
}
  
 Widget _showButtons() {
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child:Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            child: Text("Change Password"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState>states){
                return Color(0xFF120E43);
              }
            ),
            ),
            onPressed: ()=> _save(),             
            ),
          ),
      ],
    ) ,
  );
 }
 
 void _save() {
  if(!_validateFields())
  {
    return ;
  }
  _changPassword();
 }
 
  bool _validateFields() {
    bool _isValid=true;
    if(_currentPassword.length <6)
    {
      _isValid=false;
      _currentPasswordShowError=true;
      _currentPasswordError="You must enter your current password of at least 6 characters.";
    }
    else
    {
      _currentPasswordShowError=false;
    }
    if(_newPassword.length<6)
    {
       _isValid=false;
      _newPasswordShowerror=true;
      _newPasswordError="You must enter your new password of at least 6 characters.";
    }else
    {
       _newPasswordShowerror=false;
    }
    if(_confirmPassword.length<6)
    {
       _isValid=false;
      _confirmPasswordshowError=true;
     _confirmPasswordError="You must enter confirm password of at least 6 characters.";
    }
    else
    {
      _confirmPasswordshowError=false;
    }
     if(_newPassword != _confirmPassword)
    {
       _isValid=false;
      _confirmPasswordshowError=true;
     _confirmPasswordError="The new password and confirmation are not the same.";
    }
    else
    {
      _confirmPasswordshowError=false;
    }
    setState(() {
      
    });
    return _isValid;
  }
  
  void _changPassword() async{
    setState(() {
      _showLoader=true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
      Map<String, dynamic> request = {
      'oldPassword': _currentPassword,
      'newPassword': _newPassword,
      'Confirm': _confirmPassword,
    };

    Response response=await Apihelper.Post( '/api/Account/ChangePassword', request, widget.token);
    setState(() {
      _showLoader=false;
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
    await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Your password has been changed successfully.',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Accept'),
      ]
    );    

    Navigator.pop(context, 'yes');
  }
}