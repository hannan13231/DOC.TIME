
class UserModel {

  String? id , userName , userRole, specialist, address;

  UserModel({this.id, this.userName , this.userRole ,
    this.specialist, this.address});

  factory UserModel.fromJson(Map<dynamic , dynamic> json , id){
    return UserModel(
      id: id,
      userName: json['user_name'],
      userRole: json['user_role'],
      specialist: json['specialist'],
      address: json['address'],
    );
  }

}


class AppointmentModel {

  String? id , userName , date, specialist, address;

  AppointmentModel({this.id, this.userName , this.date ,
    this.specialist, this.address});

  factory AppointmentModel.fromJson(Map<dynamic , dynamic> json , id){
    return AppointmentModel(
      id: id,
      userName: json['user_name'],
      date: json['date'],
      specialist: json['specialist'],
      address: json['address'],
    );
  }

}

class DrAppointmentModel {

  String? id , userName,docName , date, specialist, address;

  DrAppointmentModel({this.id, this.userName,this.docName , this.date ,
    this.specialist, this.address});

  factory DrAppointmentModel.fromJson(Map<dynamic , dynamic> json , id){
    return DrAppointmentModel(
      id: id,
      userName: json['user_name'],
      docName: json['doc_name'],

      date: json['date'],
      specialist: json['specialist'],
      address: json['address'],
    );
  }

}

class MedicationModel {

  String? id , userName,other_illness , current_medical_history, smoking_controller, alco_controller;

  MedicationModel({this.id, this.userName,this.other_illness , this.current_medical_history ,
    this.smoking_controller, this.alco_controller});

  factory MedicationModel.fromJson(Map<dynamic , dynamic> json , id){
    return MedicationModel(
      id: id,
      userName: json['user_name'],
      other_illness: json['other_illness'],
      current_medical_history: json['current_medical_history'],
      smoking_controller: json['smoking_history'],
      alco_controller: json['alco_history'],
    );
  }

}