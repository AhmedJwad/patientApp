class Role {
  int id=0;
  String Name='';

  Role({required this.id,required this.Name});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    Name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Name'] = this.Name;
    return data;
  }
}