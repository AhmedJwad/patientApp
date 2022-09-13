
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/diagnosic_screen2.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

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
      onPressed: () {
       Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=> diagnosicscreen(
            token: widget.token, 
            diagnosic1: diagnosic (description: '' , id: 0)   ,        
          ),
          ),   
       );
      } ,   
      child: Icon(Icons.add),           
         ),
    );
   
  }
  
  void _getdiagnosics() async{
    setState(() {
      _showLoader=true;
    });
    Response response=await Apihelper.Getdiagnosics(widget.token.token);
   setState(() {
     _showLoader=false;
   }); 

   if(!response.isSuccess)
   {
    await showAlertDialog(
      context: context,
      title: 'Error',
      message: response.message,
      actions: <AlertDialogAction>[
           AlertDialogAction(key: null, label: 'Accept'),
      ]
      );
   }
   setState(() {
     _diagnosic=response.result;
   });
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
            onTap: () {
                 Navigator.push(
                    context, 
                    MaterialPageRoute(
                    builder: (context)=> diagnosicscreen(
                    token: widget.token, 
                    diagnosic1: e,        
          ),
          ),   
       );
            },    
            child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.description, style: TextStyle(fontSize: 18, ),
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