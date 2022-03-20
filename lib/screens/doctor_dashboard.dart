import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_projects/layouts/appointment_model_layout.dart';
import 'package:new_projects/models/user_model.dart';
import 'package:new_projects/screens/auth_screens/login_screen.dart';
import 'package:new_projects/utils/constants.dart';
import 'package:new_projects/utils/size_config.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  void initState() {

    _getAppointment();
    _getPatient();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAccentColor,

      body: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.hM! * 8.0,
          left: SizeConfig.iM! * 4.0,
          right: SizeConfig.iM! * 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _headerPart(context),


            Container(
              // margin: EdgeInsets.symmetric(
              //     //horizontal: SizeConfig.hM! * 2.0,
              //     vertical: SizeConfig.hM! * 2.0
              // ),
              padding: EdgeInsets.only(
                top: SizeConfig.hM! * 2.0,
              ),
              child: Text(
                "Your Appointments",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.hM! * 2.0
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.hM! * 2.0
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: appList.length,
                itemBuilder: (context , index){
                  UserModel? patient =  getUserDetails(appList[index].userName.toString());
                  return  AppointmentModelLayout(userModel: appList[index],
                    patient: patient,);
                },
              ),
            )

          ],
        ),
      ),
    );
  }
  List<DrAppointmentModel> appList = [];
  void _getAppointment() async {
   await FirebaseFirestore.instance
        .collection("doctors").doc(Constants.userModel?.id).collection("appointments")
        .get()
        .then((QuerySnapshot querySnapshot) {
      appList.clear();

      for (var doc in querySnapshot.docs) {
        appList.add(DrAppointmentModel.fromJson(doc.data() as Map, doc.id));
      }

setState(() {

});

    });
  }

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
    print(patientList);
  }

  getUserDetails(String name){
    print(name+ "  name");
    for(var i=0;i<patientList.length;i++){
      if(patientList[i].userName==name){
        return patientList[i];
      }else{
        return UserModel();
      }
    }

  }

  _headerPart(context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Hello" , style: TextStyle(
                      fontSize: SizeConfig.hM! * 1.6,
                      fontWeight: FontWeight.w500
                  ),),
                  SizedBox(height: SizeConfig.hM! * 0.7,),
                  Text("${Constants.userModel?.userName}" , style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.hM! * 2.4,
                      color: Colors.black87
                  ),),
                  SizedBox(height: SizeConfig.hM! * 0.5,),
                  Text("${Constants.userModel?.specialist}" , style: TextStyle(
                      fontSize: SizeConfig.hM! * 1.8,
                      color: Colors.black87
                  ),),
                ],
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.of(context)
                    .pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
              child: CircleAvatar(
                backgroundImage: const AssetImage("assets/images/doctor.png"),
                radius: SizeConfig.hM! * 3.5,
              ),
            )
          ],
        ),

        SizedBox(height: SizeConfig.hM! * 2.0,),
        const Divider(),
      ],
    );
  }
}
