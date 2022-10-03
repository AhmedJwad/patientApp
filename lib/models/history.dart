import 'package:healthcare/models/detail.dart';
class Histories {
  int id=0;
  String allergies='';
  String illnesses='';
  String surgeries='';
  String result='';
  String date='';
  String dateLocal='';
  List<Details> details=[];
  int detailsCount=0;

  Histories(
     {required this.id,
      required  this.allergies,
      required  this.illnesses,
      required  this.surgeries,
      required  this.result,
      required  this.date,
      required  this.dateLocal,
      required  this.details,
      required  this.detailsCount});

  Histories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    allergies = json['allergies'];
    illnesses = json['illnesses'];
    surgeries = json['surgeries'];
    result = json['result'];
    date = json['date'];
    dateLocal = json['dateLocal'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
    detailsCount = json['detailsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['allergies'] = this.allergies;
    data['illnesses'] = this.illnesses;
    data['surgeries'] = this.surgeries;
    data['result'] = this.result;
    data['date'] = this.date;
    data['dateLocal'] = this.dateLocal;   
    data['details'] = this.details.map((v) => v.toJson()).toList();   
    data['detailsCount'] = this.detailsCount;
    return data;
  }
}