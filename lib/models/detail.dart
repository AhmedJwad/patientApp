import 'package:healthcare/models/Diagnosic.dart';

  class Details {
  int id=0;
  diagnosic diagonisic=diagnosic(id: 0, description: '');
  String? description='';

  Details({required this.id,required this.diagonisic,required this.description});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diagonisic = diagnosic.fromJson(json['diagonisic']);      
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id; 
    data['diagonisic'] = this.diagonisic.toJson();    
    data['description'] = this.description;
    return data;
  }
}