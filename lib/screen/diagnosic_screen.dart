
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
        child:_showLoader ? LoaderComponent(text: ('Loading...'),) :_getcontent(),        
       ),
        floatingActionButton: FloatingActionButton(
      onPressed: () {} ,   
      child: Icon(Icons.add),           
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
  
  Widget _getcontent() {
    return _diagnosic.length==0 ? _nocontent():_getlistView();
    
  }
  
  _nocontent() {
    return Center(
     child:      
     Container(
      margin: EdgeInsets.all(20),
       child: Text('No content', 
       style: TextStyle(
        fontSize: 16 , fontWeight:FontWeight.bold,
        ),
       ),
     )
      );
  }
  
 Widget _getlistView() {
  return ListView(
    children: _diagnosic.map((e){
         return Card(
           child: InkWell(
            onTap: () {},    
            child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.description, style: TextStyle(fontSize: 16, ),
           ),
           Icon(Icons.arrow_forward_ios),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
           ),
           
    ),
         );
    }).toList(),
  );
 }
}