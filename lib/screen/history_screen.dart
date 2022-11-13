
import 'package:flutter/material.dart';
import 'package:healthcare/models/history.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';


class HistoryScreen extends StatefulWidget {
 final Token token;
 final User user;
 final Patients patient;

HistoryScreen({required this.token , required this.user , required this.patient,});

  @override
 _historyScreen createState() =>  _historyScreen();
}

class  _historyScreen extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.patient.id == 0 
            ? 'New history' 
            : 'Edit history'),
        ),
        body: Center(
          child: Text('history'),
        ),
    );
  }
}