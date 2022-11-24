import 'package:flutter/material.dart';
import 'package:healthcare/models/detail.dart';
import 'package:healthcare/models/history.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';

class DetailScreen extends StatefulWidget {
 final Token token;
 final User user ;
 final Patients patient;
 final Histories histories;
 final Details details;
 DetailScreen({required this.token, required this.user, required this.patient, required this.details, required this.histories});

  @override
  _detailScreenState createState() => _detailScreenState();
}

class _detailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body:Center(
        child: Text('details'),
      ),
    );  
  }
}