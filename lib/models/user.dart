import 'package:healthcare/models/patient.dart';

class User {
  String firstName='';
  String lastName='';
  String address='';
  String imageId='';
  String imageFullPath='';
  int userType=0;
  String fullName='';
  List<Patients> patients=[];  
  int patientsCount=0;  
  String id='';
  String userName='';  
  String email='';  
  String phoneNumber='';
  
  

  User(
      {required this.firstName,
      required this.lastName,
      required  this.address,
      required this.imageId,
      required  this.imageFullPath,
      required this.userType,
      required this.fullName,
      required this.patients, 
      required this.patientsCount,
      required this.id,
      required this.userName,      
      required this.email,      
      required this.phoneNumber,
      });
      

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    fullName = json['fullName'];    
    if (json['patients'] != null) {
      patients = [];
      json['patients'].forEach((v) {
        patients.add(new Patients.fromJson(v));
      });
    }
    patientsCount = json['patientsCount']; 
    id = json['id'];
    userName = json['userName'];    
    email = json['email'];    
    phoneNumber = json['phoneNumber'];    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address'] = this.address;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['patients'] = this.patients.map((v) => v.toJson()).toList();   
    data['patientsCount'] = this.patientsCount;   
    data['id'] = this.id;
    data['userName'] = this.userName;    
    data['email'] = this.email;    
    data['phoneNumber'] = this.phoneNumber;    
    return data;
  }
}