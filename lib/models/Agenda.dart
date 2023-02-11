import 'package:healthcare/models/UserResponse.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/patientresponse.dart';

class Agenda {
  int id=0;
  String date='';
  String? description;
  bool isAvailable=true;
  bool isMine=false;
  String dateLocal='';
  Patientresponse? patientresponse= Patientresponse(
  id: 0, 
  firstName: '', 
  lastName: '', 
  address: '',
  date: '', 
  dateLocal: '', 
  epcnNumber: 0, 
  mobilePhone: '', 
  description: '', 
   
);
  UserResponse userResponse= UserResponse(firstName: '', lastName: '', address: '', imageId: '',
   imageFullPath: '',  fullName: '', id: '', email: '', phoneNumber:'', 
   countryCode: '');

  Agenda(
      {required this.id,
      required this.date,
      this.description,
     required this.isAvailable,
     required this.isMine,
     required this.dateLocal,
      this.patientresponse,
    required  this.userResponse});

  Agenda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    description = json['description'];
    isAvailable = json['isAvailable'];
    isMine = json['isMine'];
    dateLocal = json['dateLocal'];
   patientresponse = json['patientresponse'] != null
        ? new Patientresponse.fromJson(json['patientresponse'])
        : null;
   
    userResponse= UserResponse.fromJson(json['userResponse']);
      
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['description'] = this.description;
    data['isAvailable'] = this.isAvailable;
    data['isMine'] = this.isMine;
    data['dateLocal'] = this.dateLocal;  
      if (this.patientresponse != null) {
      data['patientresponse'] = this.patientresponse!.toJson();
    } 
    data['userResponse'] = this.userResponse.toJson();
   
   
    return data;
  }
}
