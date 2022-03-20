import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_projects/models/user_model.dart';
import 'package:new_projects/screens/auth_screens/login_screen.dart';
import 'package:new_projects/screens/doctor_dashboard.dart';
import 'package:new_projects/screens/home_screen.dart';
import 'package:new_projects/utils/common_methods.dart';
import 'package:new_projects/utils/constants.dart';
import 'package:new_projects/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {

  @override
  void initState() {
    _checkUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainAccentColor,

      body: SizedBox(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: SizeConfig.iM! * 40.0,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0.0,
              child: Image.asset(
                "assets/images/login_bottom.png",
                width: SizeConfig.iM! * 35.0,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Welcome back",
                      style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: SizeConfig.hM! * 4.0,
                    ),

                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.hM! * 6.0,
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.black87,
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      )

    );
  }

  void _checkUser(context) async {
    User? user = FirebaseAuth.instance.currentUser;

    print("user = ${user?.uid}");
    await Future.delayed(const Duration(milliseconds: 500));
    if(user == null){
      if(mounted){
        Navigator
            .pushAndRemoveUntil(context,
            MaterialPageRoute(
                builder: (context) => const LoginScreen()), (route) => false);
      }
    }else{
      _getUserData(user);
    }

  }

  void _getUserData(User? user) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
        .collection(prefs.getBool("isDoctor")! ? "doctors" : "users").doc(user?.uid).get()
        .then((DocumentSnapshot snapshot){

          if(snapshot.exists){
            Constants.userModel = UserModel
                .fromJson(snapshot.data() as Map, user?.uid);

            if(Constants.userModel?.userRole == "doctor"){
              Constants.kIsUserDoctor = true;
            }else{
              Constants.kIsUserDoctor = false;
            }


            Navigator
                .pushAndRemoveUntil(context,
                MaterialPageRoute(
                    builder: (context) => Constants.kIsUserDoctor ? const DoctorDashboard()
                        : const HomeScreen()), (route) => false);
          }else{
            FirebaseAuth.instance.signOut().then((value){
              Navigator
                  .pushAndRemoveUntil(context,
                  MaterialPageRoute(
                      builder: (context) => const CustomSplashScreen()), (route) => false);
            });
          }

    }).catchError((e){
      print("firebase errpr = ${e.toString()}");
      CommonMethods.showToast(e.toString());
    });
  }


}
