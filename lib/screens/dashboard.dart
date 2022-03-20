import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_projects/layouts/appointment_layout.dart';
import 'package:new_projects/layouts/doctor_layout.dart';
import 'package:new_projects/models/user_model.dart';
import 'package:new_projects/screens/custom_splash_screen.dart';
import 'package:new_projects/screens/profileScreen.dart';
import 'package:new_projects/utils/constants.dart';
import 'package:new_projects/utils/size_config.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  List<AppointmentModel> appList = [];
  List<UserModel> docsList = [];
  List<UserModel> searchList = [];

  @override
  void initState() {
    _getDoctors();
    _getAppointment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.hM! * 8.0,
        left: SizeConfig.iM! * 4.0,
        right: SizeConfig.iM! * 4.0,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerPart(context),
            isLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 58.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _todayAppointments(),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Text(
                          "Doctors List",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.hM! * 2.0),
                        ),
                      ),
                      _getDoctorsList(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  TextEditingController doctorText =new TextEditingController();

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
                  Text(
                    "Hello",
                    style: TextStyle(
                        fontSize: SizeConfig.hM! * 1.6,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: SizeConfig.hM! * 0.7,
                  ),
                  Text(
                    "${Constants.userModel?.userName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.hM! * 2.4,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                });
              },
              child: CircleAvatar(
                backgroundImage: const AssetImage("assets/images/patient.png"),
                radius: SizeConfig.hM! * 3.5,
              ),
            )
          ],
        ),
        SizedBox(
          height: SizeConfig.hM! * 2.0,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.iM! * 0.0,
            vertical: SizeConfig.hM! * 2.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.iM! * 2.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.5),
          ),
          alignment: Alignment.center,
          child:  TextFormField(
            controller: doctorText,
            onChanged: (value){
           setState(() {
             searchList = [];
           });
              docsList.forEach((item){
                if(item.userName==value || item.userRole==value){
               setState(() {
                 searchList.add(item);
               });
                }
              });

              },
            decoration: InputDecoration(
              border: InputBorder.none,
              isCollapsed: false,
              hintText: "Search a doctor",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        )
      ],
    );
  }

  _todayAppointments() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              if(appList.length!=0)
              Expanded(
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: 15.0),
                    child: Text(
                "Recent Appointment",
                style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.hM! * 2.0),
              ),
                  )),
              // TextButton(
              //   child: const Text(
              //     "See All",
              //     style: TextStyle(color: Colors.orangeAccent),
              //   ),
              //   onPressed: () {},
              // ),
            ],
          ),
           if(appList.length!=0)
           AppointmentLayout(
            appointmentModel:AppointmentModel(
                id: appList[0].id,
                userName:appList[0].userName,
              date: appList[0].date,
              specialist:appList[0].specialist,
              address:appList[0].address,
            ),
           ),
        ],
      ),
    );
  }

  _getDoctorsList() {
    return Container(
      child:searchList.length==0?ListView.builder(
        itemCount: docsList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return DoctorLayout(
            userModel: docsList[index],
          );
        },
      ):ListView.builder(
        itemCount: searchList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return DoctorLayout(
            userModel: searchList[index],
          );
        },
      )
    );
  }

  void _getDoctors() async {
    FirebaseFirestore.instance
        .collection("doctors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      docsList.clear();

      for (var doc in querySnapshot.docs) {
        docsList.add(UserModel.fromJson(doc.data() as Map, doc.id));
      }

      // setState(() {
      //   isLoading = false;
      // })
    });

  }

  void _getAppointment() async {
    FirebaseFirestore.instance
        .collection("users").doc(Constants.userModel?.id).collection("appointments")
        .get()
        .then((QuerySnapshot querySnapshot) {
      appList.clear();

      for (var doc in querySnapshot.docs) {
        appList.add(AppointmentModel.fromJson(doc.data() as Map, doc.id));
      }

      setState(() {
        isLoading = false;
      });


    });

 await   getdata();
  }

  getdata(){
    print('**********########################************');
    for(var i=0;i<docsList.length;i++){
      print(docsList[i].userName);
    }
    print('*************************************************');
    for(var i=0;i<appList.length;i++){
      print(appList[i]);
    }
  }
}


