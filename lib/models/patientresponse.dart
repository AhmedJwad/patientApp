class Patientresponse {
   int id=0;
  String firstName='';
  String lastName='';
  String address='';
  String date='';
  String dateLocal='';
  int epcnNumber=0;
  String mobilePhone='';
  String description='';
  String email='';

  Patientresponse(
      {required this.id,
       required this.firstName,
       required this.lastName,
       required this.address,
       required this.date,
       required this.dateLocal,
       required this.epcnNumber,
       required this.mobilePhone,
       required this.description,
      required this .email});

  Patientresponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    address = json['address'];
    date = json['date'];
    dateLocal = json['dateLocal'];
    epcnNumber = json['epcnNumber'];
    mobilePhone = json['mobilePhone'];
    description = json['description'];
    email=json['email'];
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
    data['email'] = this.email;    
    return data;
  }
}