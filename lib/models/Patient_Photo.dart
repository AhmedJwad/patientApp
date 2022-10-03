
class PatientPhotos {
  int id=0;
  String imageId='';
  String imageFullPath='';

  PatientPhotos({required this.id,required this.imageId,required this.imageFullPath});

  PatientPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    return data;
  }
}
