
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/screen/home_screen.dart';
import 'package:healthcare/screen/recovery_password_screen.dart';
import 'package:healthcare/screen/register_user_screen.dart';
import 'package:http/http.dart'as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String _email = '';
  String _emailError = '';
  bool _showemailError=false;
  String _password = '';
  String _passworderror='';
  bool _showPasswordError=false;
  bool _rememberMe = true;
  bool _passwordshow=false;
  bool _showLoader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body:Stack(    
         children: <Widget>[
          SingleChildScrollView(
            child:Column(
             mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[   
                 SizedBox(height: 40,),             
                   _showlogo(),
                    SizedBox(height: 20,),
                    _showemail(),
                    _showpassword(),
                    _showRememberMe(),
                    _showforgetPassword(),
                    _showButtons(),                   
            ],
            ),
             ),        
             _showLoader ? LoaderComponent(text: "Loading ",):Container(),
        ],
      )
      

    );
  }
  
 Widget _showlogo() {

  return Image(image: AssetImage('assets/logo.jpg'), width: 300,);
 }
 
 Widget _showemail() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(      
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'please inserrt your email',
        labelText: 'email',
        errorText: _showemailError?_emailError:null,
        prefixIcon: Icon(Icons.alternate_email),
        suffixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),      
      ),
      onChanged: (value){
        _email = value;       
      },
    ),
  );
 }

Widget _showpassword() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(     
    obscureText: !_passwordshow,
      decoration: InputDecoration(
        hintText: 'please inserrt your Password',
        labelText: 'Password',
        errorText: _showPasswordError?_passworderror:null,
        prefixIcon: Icon(Icons.lock),
        suffixIcon:IconButton( icon: _passwordshow ?  Icon(Icons.visibility) : Icon(Icons.visibility_off),
        onPressed: (){
          setState(() {
            
          });
          _passwordshow=!_passwordshow;
        }) ,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),      
      ),
      onChanged: (value){
        _password = value;       
      },
    ),
  ); 
}

 Widget _showRememberMe() {
  return CheckboxListTile(
    title: Text('Remember Me'),
    value: _rememberMe, onChanged: (value) { 
    setState(() {
      _rememberMe=value!;
    });
   },);
 }
 
 Widget _showButtons() { 
  
  return Container(    
    margin: EdgeInsets.only(left:10, right: 10,bottom: 10, top: 10),  

    child: Column(
      children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,           
         children: <Widget>[  
           _showLoginButton(),
        
         SizedBox(width:20,),
         _showRegisterButton(),       
         ],
        ),
        _showGoogleLoginbutton(),
        _showFacebookLoginButton(),
      ],
    ),
  );
 }
 
 void _login() async {
  setState(() {
    _passwordshow=false;
  });
  if (!_validatesfiels())
  {
    return;
  }

  setState(() {
    _showLoader=true;
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
  Map<String , dynamic>request={
    "Username":_email,
    "Password":_password,

  };
  
  var url=await Uri.parse('${constans.apiUrl}/api/Account/CreateToken');
  var response=await http.post(
    url, 
  headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
  },
   body:jsonEncode(request)
   );

   setState(() {
    _showLoader=false;
  });
   if(response.statusCode >= 400)
   {
    setState(() {
      _showPasswordError=true;
      _passworderror="email or password incoorect";
    });
    return;
   }

  var body =response.body;
  if(_rememberMe)
  {
    _storeUser(body);
  }
  var decodejson = jsonDecode(body);
  var token=Token.fromJson(decodejson);   
 Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeScreen(token: token,)
      )
    );
}

  bool _validatesfiels() {
    bool isValid=true;
    if(_email.isEmpty)
    {
      isValid=false;
      _showemailError=true;
      _emailError="please insert your Email";
    }else if (!EmailValidator.validate(_email))
    {
       isValid=false;
      _showemailError=true;
      _emailError="please insert correct email address";
    }
    else
    {
      _showemailError=false;
    }

     if(_password.isEmpty)
    {
      isValid=false;
      _showPasswordError=true;
      _passworderror="please insert your Password";
    }
    else
    {
      _showPasswordError=false;
    }
    setState(() {
      
    });
    return isValid;
  }
  
  void _storeUser(String body)async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    await pref.setBool('isRemembered', true);
    await pref.setString('userBody', body);
  }
  
 void _register() {
  Navigator.push(
    context, 
   MaterialPageRoute(builder: (context)=> RegisterUserScreen())
    );
 }
 
 Widget _showforgetPassword() {
  return InkWell(
    onTap: ()=> _goForgetPassword(),
    child: Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Text('Forgot password ' , style: TextStyle(color: Colors.blue),),
    ),
  );
 }
 
 void _goForgetPassword() {
  Navigator.push(context, MaterialPageRoute(builder: (context)=> RecoverPasswordScreen()));
 }
 
 Widget _showLoginButton() {
  return  Expanded(                 
       child: ElevatedButton(
       child:Text('Login'),
       style: ButtonStyle(
       backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState>states){
            return Color(0xFF120E43);
          }
        )
        ),
        onPressed: ()=>_login()
        ),
     );

 }
 
 Widget _showRegisterButton() {
  return Expanded(
        child: ElevatedButton(
        child:Text('Register'),
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFFE03B8B);
            }
          ),
        ),
           onPressed: ()=>_register()
           ),
       );
 }
 
  Widget _showGoogleLoginbutton() {
    return Row(
      children: <Widget>[
        Expanded(child: ElevatedButton.icon(
          onPressed:()=> _loginGoogle(), 
          icon:FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ), 
           label: Text("Login with google"),
           style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary:Colors.black),
          )),
      ],
    );
  }
  
 void _loginGoogle() async{
    setState(() {
      _showLoader=true;
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
    var googleSignIn=GoogleSignIn();   
     await googleSignIn.signIn().catchError((onError) {
          print("Error $onError");
           return null;
        });
    await googleSignIn.signOut();
    
    var user=await googleSignIn.signIn();
    if(user==null)
    {
      setState(() {
        _showLoader=false;
      });
    
    await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'There was a problem getting the Google username, please try again later.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    Map<String , dynamic> request={
      'email':user.email,
      'id':user.id,
      'loginType':1,
      'photoURL':user.photoUrl,
      'fullName':user.displayName,
    };
      await _socialLogin(request);
  }
  
 Widget _showFacebookLoginButton() {
  return Row(
      children: <Widget>[
        Expanded(child: ElevatedButton.icon(
          onPressed:()=> _loginFacebook(), 
          icon:FaIcon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
            ), 
           label: Text("Login with Facebook"),
           style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary:Colors.black),
          )),
      ],
    );
 }
 
 void _loginFacebook() async{
  setState(() {
      _showLoader=true;
    });
    await FacebookAuth.i.logOut();
    var result= await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );
    if(result.status!=LoginStatus.success)
    {
      setState(() {
        _showLoader = false;
      });
 
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'There was a problem getting the Facebook username, please try again later.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    final requestData = await FacebookAuth.i.getUserData(
      fields: "email, name, picture.width(800).heigth(800), first_name, last_name",
    );

    var picture = requestData['picture'];
    var data = picture['data'];

    Map<String, dynamic> request = {
      'email': requestData['email'],
      'id': requestData['id'],
      'loginType': 2,
      'fullName': requestData['name'],
      'photoURL': data['url'],
      'firtsName': requestData['first_name'],
      'lastName': requestData['last_name'],
    };

    await _socialLogin(request);
  }
  
 Future  _socialLogin(Map<String, dynamic> request) async{
  setState(() {
      _showLoader=true;
    });
   var url = Uri.parse('${constans.apiUrl}/api/Account/SocialLogin');
   var bodyRequest=jsonEncode(request);
   var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
      body: bodyRequest,
    );
   setState(() {
     _showLoader=false;
   });
   if(response.statusCode >= 400)
   {
    await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'The user has already logged in previously by email or another social network..',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );   
      return; 
   }
   var body=response.body;

   if(_rememberMe)
   {
    _storeUser(body);
   }
   var decodejson=jsonDecode(body);
   var token=Token.fromJson(decodejson);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeScreen(token: token,)
      )
    );
 }
  
 
  
 
 }
 
  
 
 



