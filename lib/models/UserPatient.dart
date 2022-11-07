
import 'package:flutter/material.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/models/patient.dart';
class userpatient {
	int id=0;
	User user=User(id:"" ,firstName:"" ,  lastName:"",  address:'',imageId:"",imageFullPath:'' ,patients:[],patientsCount:0 ,
  userName:'',email:'',phoneNumber:'',userType: 0, fullName: '');   
	List<Patients>? patients;
	int patientsCount=0;

	userpatient({required this.id,required this.user,required this.patients,required this.patientsCount});

	userpatient.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		user =  User.fromJson(json['user']) ;
		if (json['patients'] != null) {
			patients = <Patients>[];
			json['patients'].forEach((v) { patients!.add(new Patients.fromJson(v)); });
		}
		patientsCount = json['patientsCount'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		if (this.user != null) {
      data['user'] = this.user.toJson();
    }
		if (this.patients != null) {
      data['patients'] = this.patients!.map((v) => v.toJson()).toList();
    }
		data['patientsCount'] = this.patientsCount;
		return data;
	}
}
