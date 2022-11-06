import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/home_screen.dart';
import 'package:healthcare/screen/login_screen.dart';
import 'package:healthcare/screen/wait_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() =>_MyAppState();
}

class _MyAppState extends State<MyApp> {
   bool _isLoading=true;
    bool _showLoginPage=true;
    late Token _token;  
   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHome();
  }
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthCare App',
      home: _isLoading 
        ? WaitScreen() 
        : _showLoginPage 
          ?loginScreen() 
          : HomeScreen(token: _token),
    );  
    
  }
  
  void _getHome() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    bool isRemember=preferences.getBool('isRemembered')??false;
    if(isRemember)
    {
      String? userbody=preferences.getString('userBody');
      if(userbody !=null)
      {
        var decodedJson=jsonDecode(userbody);
        _token = Token.fromJson(decodedJson);
        if (DateTime.parse(_token.expiration).isAfter(DateTime.now())) {
          _showLoginPage = false;
        }
      }       
    }
     _isLoading = false;
    setState(() {});
  }
 
}