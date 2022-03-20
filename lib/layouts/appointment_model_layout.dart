import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_projects/models/user_model.dart';
import 'package:new_projects/screens/patient_layout.dart';
import 'package:new_projects/utils/common_methods.dart';
import 'package:new_projects/utils/constants.dart';
import 'package:new_projects/utils/size_config.dart';

class AppointmentModelLayout extends StatefulWidget {
  final DrAppointmentModel? userModel;
  final UserModel? patient;

   AppointmentModelLayout({this.userModel,this.patient, Key? key}) : super(key: key);


  @override
  State<AppointmentModelLayout> createState() => _AppointmentModelLayoutState();
}

class _AppointmentModelLayoutState extends State<AppointmentModelLayout> {

  bool isAccepted = false;
  bool isCanceled = false;


  List<UserModel> patientList = [];
  void _getPatient() async {
    await FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      patientList.clear();

      for (var doc in querySnapshot.docs) {
        setState(() {
          patientList.add(UserModel.fromJson(doc.data() as Map, doc.id));
        });
      }

      // setState(() {
      //   isLoading = false;
      // })
    });
    print("Appoint");
    print(patientList);
  }

  getUserDetails(String name){
    print(name+ "  name");
    for(var i=0;i<patientList.length;i++){
      print(patientList[i].userName);
      if(patientList[i].userName==name){
        print("true");
        print(patientList[i].userName);
        return patientList[i];
      }
    }
  }

  @override
  void initState() {
    print("next");
    print("${widget.patient?.userName.toString()}");
    _getPatient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.hM! * 1.0,
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.hM! * 1.0,
        horizontal: SizeConfig.hM! * 1.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.2),
        color: Colors.white
      ),
      child: Column(
        children: [

          Row(
            children: [

              CircleAvatar(
                backgroundImage: const AssetImage("assets/images/patient.png"),
                radius: SizeConfig.hM! * 3.5,
              ),

              SizedBox(width: SizeConfig.iM! * 2.0,),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.userModel!.userName,
                            style: TextStyle(
                                fontSize: SizeConfig.hM! * 2.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        TextSpan(
                            text: "\nDental Disease",
                            style: TextStyle(
                                fontSize: SizeConfig.hM! * 1.6,
                                color: Colors.black45,
                                height: 2.0
                            )
                        ),
                      ]
                  ),
                ),
              )

            ],
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: SizeConfig.hM! * 3.0,
              bottom: SizeConfig.hM! * 1.0,
            ),
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.hM! * 2.0,
              horizontal: SizeConfig.hM! * 2.0,
            ),
            decoration: BoxDecoration(
                color: kMainAccentColor,
                borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.5)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _dateTimeItem(   widget.userModel!.date.toString()),
                    SizedBox(width: SizeConfig.iM! * 1.0 ,),

                  ],
                ),

              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(
              top: SizeConfig.hM! * 2.0
            ),
            child: Row(
              children: [

                isAccepted ? const SizedBox.shrink()
                    : _button(isCanceled ? "Canceled" : "Cancel", false),
                SizedBox(width: SizeConfig.hM! * 4.0,),
                isCanceled ? const SizedBox.shrink()
                    : _button(isAccepted ? "Accepted" : "Accept" , true),

              ],
            ),
          )

        ],
      ),
    );
  }

  _dateTimeItem(String txt) {
    return Expanded(
      child: Row(
        children: [
          Icon(txt.contains("Monday") ? Icons.calendar_today_sharp
              : txt.contains("MG") ? Icons.location_on
              : Icons.access_time, color: Colors.black87,),
          SizedBox(width: SizeConfig.iM! * 2.0,),
          Text(txt , style: TextStyle(
              fontSize: SizeConfig.hM! * 1.5
          ),)
        ],
      ),
    );
  }

  _button(String txt , bool isAccept) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if(isAccept){
            CommonMethods.showToast("Appointment is accepted");
            isAccepted = true;
            isCanceled = false;
            UserModel? patient =  await getUserDetails(widget.userModel!.userName.toString());
            print('P name'+patient!.userName.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  PatientProfileScreen(
                      patient,widget.userModel!.specialist)),
            );
          }else{
            CommonMethods.showToast("Appointment is canceled");
            isCanceled = true;
            isAccepted = false;
          }
          setState(() {

          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.hM! * 1.0,
            vertical: SizeConfig.hM! * 1.5,
          ),
          decoration: BoxDecoration(
            color: isAccept ? Colors.black87 : kMainAccentColor,
            borderRadius: BorderRadius.circular(SizeConfig.hM! * 5.0),
          ),
          child: Text(txt , style: TextStyle(
            color: isAccept ? kMainAccentColor : Colors.black87,
            fontSize: SizeConfig.hM! * 1.6,
            fontWeight: FontWeight.w500
          ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
