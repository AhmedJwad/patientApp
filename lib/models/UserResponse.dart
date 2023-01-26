class UserResponse {
  String id='';
  String email='';
  String firstName='';
  String lastName='';
  String countryCode='';
  String address='';
  String imageId='';
  String imageFullPath='';
  String fullName='';
  String phoneNumber='';

  UserResponse(
      {required this.id,
     required this.email,
     required this.firstName,
     required this.lastName,
     required this.countryCode,
     required this.address,
     required this.imageId,
     required this.imageFullPath,
     required this.fullName,
     required this.phoneNumber});

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    countryCode = json['countryCode'];
    address = json['address'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['countryCode'] = this.countryCode;
    data['address'] = this.address;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}