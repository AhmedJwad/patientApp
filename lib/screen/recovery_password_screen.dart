
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import "package:flutter/material.dart";
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/response.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  _recoverPasswordScreenState createState() =>_recoverPasswordScreenState();
}

class _recoverPasswordScreenState extends State<RecoverPasswordScreen> {
  bool _showLoader=false;

  String _email='';
  String _emailerror='';
  bool _emailshowerror=false;
  TextEditingController _emailtextcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recovery Password"),),  
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
               _showEmail(),
              _showButtons(),
            ],
          ),
          _showLoader ? LoaderComponent(text: "Loading...",):Container(),
        ],
      ),  
    );
  }
  
 Widget _showEmail() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      keyboardType: TextInputType.emailAddress,
     decoration: InputDecoration(      
      hintText: "Enter your email",
      labelText: "Email",
      errorText: _emailshowerror? _emailerror:null,
      prefixIcon:Icon(Icons.alternate_email),
      suffixIcon: Icon(Icons.email),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
     ),
     onChanged: ((value) {
       _email=value;
     }), 
    ),
  );
 }
  
Widget  _showButtons() {
  return  Container(
    margin: EdgeInsets.only(left: 10 , right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       Expanded(child: ElevatedButton(
        child:Text("Recover password"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFF120E43);
            }
          ),
        ),
        onPressed: ()=>_recoverPassword(),
        )
        ),
      ],      
    ),
  );
}

 void _recoverPassword() async{
  if(!validatefields())
  {
    return;
  }
   _sendRecoverPassword();
 }
 
  bool validatefields() {
    bool _isValid=true;
    
    if(_email.isEmpty)
    {
      _isValid=false;
      _emailshowerror=true;
      _emailerror='please insert your email..';
    }else if(!EmailValidator.validate(_email))
    {
       _isValid=false;
      _emailshowerror=true;
      _emailerror='please insert correct email..';
    }else
    {
      _emailshowerror=true;
    }
    setState(() {
      
    });
    return _isValid;
  }
  
  void _sendRecoverPassword() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Map<String, dynamic> request = {
      'email': _email,
    };

    Response response = await Apihelper.PostnoToken(
      '/api/Account/RecoverPassword', 
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
        ]
      );    
      return;
    }

    await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'An email has been sent to you with instructions to recover your password.',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Accept'),
      ]
    );    

    Navigator.pop(context);
  }  
  
}