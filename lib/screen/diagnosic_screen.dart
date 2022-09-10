
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:http/http.dart'as http;
class DiagnosicScreen extends StatefulWidget {
  final Token token ;

  DiagnosicScreen({required this.token});

  @override
 _diagnosicScreen createState() => _diagnosicScreen();
}

class _diagnosicScreen extends State<DiagnosicScreen> {
  List<diagnosic> _diagnosic= [];
   bool _showLoader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdiagnosics();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title:Text ('diagnosics')),
       body: Center(
        child:_showLoader ? LoaderComponent(text: ('Loading...'),) :Text('diagnosics'),
        
       ),
    );
    
  }
  
  void _getdiagnosics() async{
    setState(() {
      _showLoader=true;
    });
    var url=Uri.parse('${constans.apiUrl}/api/diagonisics');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${widget.token.token}' ,
          } , 
   );  
   setState(() {
     _showLoader=false;
   });

   var body=response.body;
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       _diagnosic.add(diagnosic.fromJson(item));
     }
   }
   print(_diagnosic);


  }
}