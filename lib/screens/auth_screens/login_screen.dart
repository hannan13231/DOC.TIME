import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_projects/layouts/action_button.dart';
import 'package:new_projects/screens/custom_splash_screen.dart';
import 'package:new_projects/screens/doctor_dashboard.dart';
import 'package:new_projects/screens/home_screen.dart';
import 'package:new_projects/utils/common_methods.dart';
import 'package:new_projects/utils/constants.dart';
import 'package:new_projects/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRoleSelected = false;
  bool isDoctor = false;
  bool isLogin = true;
  ImagePicker picker = ImagePicker();
  String email = '', password = '', userName = '',name='',age='',phNum='',addr='';
  File imageFile = new File( "assets/images/login_bottom.png");
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
              child: Image.asset(
                "assets/images/login_bottom.png",
                width: SizeConfig.iM! * 35.0,
              ),
            ),
            Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isRoleSelected? Padding(
                      padding:  EdgeInsets.only(top: 15.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(onPressed: (){
                            setState(() {
                              isRoleSelected = false;
                            });
                          }, icon: Icon(Icons.person_rounded,size: 30.0,))),
                    ):SizedBox(),
                    SizedBox(
                      height: SizeConfig.hM! * 1.0,
                    ),
                    const Text(
                      "Welcome back",
                      style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: SizeConfig.hM! * 1.0,
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.normal),
                    ),


                    isRoleSelected
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.hM! * 2.0),
                                child: SvgPicture.asset(
                                  "assets/svgs/loginsvg.svg",
                                  height: SizeConfig.hM! * 22.0,
                                ),
                              ),

                              /////////// FIELDS ////////////////
                              // isLogin
                              //     ? SizedBox.shrink()
                              //     : _textField(context, "User Name", true),
                              if(imageFile.path.isNotEmpty && !isLogin)
                                GestureDetector(
                                  onTap: () async {
                                    var image = await picker.pickImage(source: ImageSource.gallery);
                                    print(image!.path);
                                    var imgPath  = image.path;
                                    setState(() {
                                      imageFile = File(imgPath);
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage:FileImage(imageFile),
                                  ),
                                ),
                              SizedBox(
                                height: SizeConfig.hM! * 1.0,
                              ),
                              isLogin
                                  ? SizedBox.shrink()
                                  :  _textField(context, "Name", true),
                              isLogin
                                  ? SizedBox.shrink()
                                  :  _textField(context, "Age", true),
                              isLogin
                                  ? SizedBox.shrink()
                                  :  _textField(context, "Address", true),
                              isLogin
                                  ? SizedBox.shrink()
                                  :  _textField(context, "Phone Number", true),
                              _textFieldForEmail(context, "Email", true),

                              _textFieldForPassword(context, "Password", false),

                              ActionButton(
                                txt: "Login",
                                hMargin: SizeConfig.iM! * 8.0,
                                vMargin: SizeConfig.hM! * 4.0,
                                action: () async {
                                  if (isLogin) {
                                    await _loginUser(context);
                                  } else {
                                    await _signUpUser(context);
                                  }
                                },
                              ),
                            ],
                          )
                        : _selectRole(),
                    isRoleSelected
                        ? isLogin
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = false;
                                    emailText.text ="";
                                    passText.text="";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white.withOpacity(0.6)),
                                  child: const Text("Sign up"),
                                ),
                              )
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = true;
                                    emailText.text ="";
                                    passText.text="";
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.white.withOpacity(0.6)),
                                    child: const Text("Login")),
                              )
                        : const SizedBox.shrink(),
                    // isRoleSelected
                    //     ? TextButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             isRoleSelected = false;
                    //           });
                    //         },
                    //         child: const Text("Select Role"),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController emailText = new TextEditingController();
  TextEditingController passText = new TextEditingController();

  Widget _textField(context, String hint, bool isEmail) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.hM! * 1.0,
        horizontal: SizeConfig.iM! * 8.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
          //color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black)),
      child: TextFormField(
        validator: (input) {
          // return !isValidUsername(input)
          //     ? "Please provide valid username"
          //     : null;
        },
        keyboardType: hint == "Age" ||  hint == "Phone Number"?TextInputType.number:TextInputType.text,
        //onSaved: (input) =>,
        onChanged: (String value) {
          if (hint == "Email") {
            email = value;
          } else if (hint == "Password") {
            password = value;
          } else if (hint == "Name") {
            name=value;
          }else if (hint == "Age") {
          age=value;
          }else if (hint == "Phone Number") {
          phNum=value;
          }else if (hint == "Address") {
            addr=value;
          }
        },
        cursorColor: Colors.black,
        decoration: InputDecoration(
          icon: Icon(
            isEmail ? Icons.person : Icons.lock,
            color: Colors.black54,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.hM! * 1.6,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
        obscureText: isEmail ? false : true,
      ),
    );
  }

  Widget _textFieldForEmail(context, String hint, bool isEmail) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.hM! * 1.0,
        horizontal: SizeConfig.iM! * 8.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        //color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black)),
      child: TextFormField(
        validator: (input) {
          // return !isValidUsername(input)
          //     ? "Please provide valid username"
          //     : null;
        },
        controller: emailText,
        //onSaved: (input) =>,
        onChanged: (String value) {
          if (hint == "Email") {
            email = value;
          } else if (hint == "Password") {
            password = value;
          } else {
            userName = value;
          }
        },
        cursorColor: Colors.black,
        decoration: InputDecoration(
          icon: Icon(
            isEmail ? Icons.person : Icons.lock,
            color: Colors.black54,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.hM! * 1.6,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
        obscureText: isEmail ? false : true,
      ),
    );
  }

  Widget _textFieldForPassword(context, String hint, bool isEmail) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.hM! * 1.0,
        horizontal: SizeConfig.iM! * 8.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        //color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black)),
      child: TextFormField(
        validator: (input) {
          // return !isValidUsername(input)
          //     ? "Please provide valid username"
          //     : null;
        },
        //onSaved: (input) =>,
        controller: passText,
        onChanged: (String value) {
          if (hint == "Email") {
            email = value;
          } else if (hint == "Password") {
            password = value;
          } else {
            userName = value;
          }
        },
        cursorColor: Colors.black,
        decoration: InputDecoration(
          icon: Icon(
            isEmail ? Icons.person : Icons.lock,
            color: Colors.black54,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.hM! * 1.6,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
        obscureText: isEmail ? false : true,
      ),
    );
  }

  bool isValidUsername(input) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
    return input != null && emailValid ? true : false;
  }

  _selectRole() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.hM! * 14.0,
          ),
          Text(
            "Please select your role",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: SizeConfig.hM! * 2.0),
          ),
          SizedBox(
            height: SizeConfig.hM! * 6.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.iM! * 8.0),
            child: Row(
              children: [
                _item("doctor"),
                _item("patient"),
              ],
            ),
          )
        ],
      ),
    );
  }

  _item(String icon) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isRoleSelected = !isRoleSelected;
            if (icon == "doctor") {
              isDoctor = true;
              Constants.kIsUserDoctor = true;
            } else {
              isDoctor = false;
              Constants.kIsUserDoctor = false;
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(SizeConfig.hM! * 2.0),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.orangeAccent),
          child: Image.asset(
            "assets/images/$icon.png",
            height: SizeConfig.hM! * 8.0,
          ),
        ),
      ),
    );
  }

  Future _loginUser(BuildContext context) async {
    if (emailText.text.isEmpty || passText.text.length < 5) {
      CommonMethods.showToast("Please enter valid email and password");
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailText.text,
        password: passText.text,
      )
          .catchError((e) {
        CommonMethods.showToast(e.toString());
        print("error $e");
      });

      if (user.user != null) {
        FirebaseFirestore.instance
            .collection("doctors")
            .doc(user.user?.uid)
            .update({
          'address': "Off Solapur Road, Hadapsar, Pune - 411028",
          'specialist': "Endocrinologist",
        });
        var shares = await SharedPreferences.getInstance();
        shares.setBool("isDoctor", Constants.kIsUserDoctor);
        CommonMethods.navigateTo(context, const CustomSplashScreen());
      }
    }
  }

  Future _signUpUser(BuildContext context) async {
    if (emailText.text.isEmpty || passText.text.length < 5) {
      CommonMethods.showToast("Please enter valid email and password");
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailText.text,
        password: passText.text,
      )
          .catchError((e) {
        CommonMethods.showToast(e.toString());
        print("error $e");
      });

      if (user.user != null) {
        FirebaseFirestore.instance
            .collection(Constants.kIsUserDoctor ? "doctors" : "users")
            .doc(user.user?.uid)
            .set({
          'user_name': name,
          'name': name,
          'age': age,
          'ph_num': phNum,
          'address': addr,
          'user_role': Constants.kIsUserDoctor ? "doctor" : "patient",
        }).then((value) async {
          var shares = await SharedPreferences.getInstance();
          shares.setBool("isDoctor", Constants.kIsUserDoctor);
          CommonMethods.navigateTo(context, const LoginScreen());
        });
      }
    }
  }
}
