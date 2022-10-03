import 'package:healthcare/models/Patient_Photo.dart';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/gendre.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/history.dart';
import 'package:http/http.dart';
class Patients {
  int id=0;
  String firstName='';
  String lastName='';
  String address='';
  String date='';
  String dateLocal='';
  int epcnNumber=0;
  String mobilePhone='';
  String description='';
  int age=0;
  int patientPhotosCount=0;
  String fullName='';
  String imageFullPath='';
  int historiesCount=0;
  List<PatientPhotos> patientPhotos=[];
  List<Histories> histories=[];
  City city=City(id: 0, description: '');
  Natinality natianality=Natinality(id: 0, description: '');
  Gendre gendre=Gendre(id: 0, description: '');
  bloodtypes bloodType=bloodtypes(id: 0, description: '');

  Patients(
      {required this.id,
       required this.firstName,
       required this.lastName,
       required this.address,
       required this.date,
       required this.dateLocal,
       required this.epcnNumber,
       required this.mobilePhone,
       required this.description,
       required this.age,
       required this.patientPhotosCount,
       required this.fullName,
       required this.imageFullPath,
       required this.historiesCount,
       required this.patientPhotos,
       required this.histories,
       required this.city,
       required this.natianality,
       required this.gendre,
       required this.bloodType});

  Patients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    date = json['date'];
    dateLocal = json['dateLocal'];
    epcnNumber = json['epcnNumber'];
    mobilePhone = json['mobilePhone'];
    description = json['description'];
    age = json['age'];
    patientPhotosCount = json['patientPhotosCount'];
    fullName = json['fullName'];
    imageFullPath = json['imageFullPath'];
    historiesCount = json['historiesCount'];
    if (json['patientPhotos'] != null) {
      patientPhotos = <PatientPhotos>[];
      json['patientPhotos'].forEach((v) {
        patientPhotos.add(new PatientPhotos.fromJson(v));
      });
    }
    if (json['histories'] != null) {
      histories = <Histories>[];
      json['histories'].forEach((v) {
        histories.add(new Histories.fromJson(v));
      });
    }
    city = City.fromJson(json['city']) ;
    natianality =Natinality.fromJson(json['natianality']);        
    gendre = Gendre.fromJson(json['gendre']) ;
    bloodType = bloodtypes.fromJson(json['bloodType']);       
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address'] = this.address;
    data['date'] = this.date;
    data['dateLocal'] = this.dateLocal;
    data['epcnNumber'] = this.epcnNumber;
    data['mobilePhone'] = this.mobilePhone;
    data['description'] = this.description;
    data['age'] = this.age;
    data['patientPhotosCount'] = this.patientPhotosCount;
    data['fullName'] = this.fullName;
    data['imageFullPath'] = this.imageFullPath;
    data['historiesCount'] = this.historiesCount;   
    data['patientPhotos'] = this.patientPhotos.map((v) => v.toJson()).toList();  
    data['histories'] = this.histories.map((v) => v.toJson()).toList();   
    data['city'] = this.city.toJson();   
    data['natianality'] = this.natianality.toJson();   
    data['gendre'] = this.gendre.toJson();    
    data['bloodType'] = this.bloodType.toJson();   
    return data;
  }
}
