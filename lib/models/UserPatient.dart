class UserPatient {
  int id=0;
  String firstName='';
  String lastName='';
  String address='';
  String phoneNumber='';
  String email='';

  UserPatient({required this.id,required this.firstName,required this.lastName,required this.address,
   required this.phoneNumber,required this.email});

  UserPatient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
   firstName = json['firstName'];
   lastName = json['lastName'];
   address = json['address'];
   phoneNumber = json['phoneNumber'];
   email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    return data;
  }
}