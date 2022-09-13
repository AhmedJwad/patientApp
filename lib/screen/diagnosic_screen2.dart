import 'package:flutter/material.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/Diagnosic.dart';
class diagnosicscreen extends StatefulWidget {
 final Token token;
 final diagnosic diagnosic1;
 diagnosicscreen({required this.token , required this.diagnosic1});
  @override
  _diagnosicscreenState createState() => _diagnosicscreenState();
}

class  _diagnosicscreenState extends State<diagnosicscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(title:Text(widget.diagnosic1.id==0 ? 'New diagnosic' : widget.diagnosic1.description), ) ,   
       body: Center(
        child: Text(widget.diagnosic1.id==0 ? 'New diagnosic' : widget.diagnosic1.description),
       ),   
    );
  }
}