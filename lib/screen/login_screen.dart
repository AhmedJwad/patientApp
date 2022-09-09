
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/home_screen.dart';
import 'package:http/http.dart'as http;

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
                   _showlogo(),
                    SizedBox(height: 20,),
                    _showemail(),
                    _showpassword(),
                    _showRememberMe(),
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

    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,           
     children: <Widget>[  
     Expanded(                 
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
     ),
     SizedBox(width:20,),
       Expanded(
        child: ElevatedButton(
        child:Text('Register'),
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFFE03B8B);
            }
          ),
        ),
           onPressed: (){}
           ),
       ),
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
  
 
 }
 
  
 
 



