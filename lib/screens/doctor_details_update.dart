import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';
import '../utils/common_methods.dart';
import '../utils/size_config.dart';

class UpdateDoctorDetails extends StatefulWidget {
  const UpdateDoctorDetails({Key? key}) : super(key: key);

  @override
  _UpdateDoctorDetailsState createState() => _UpdateDoctorDetailsState();
}

class _UpdateDoctorDetailsState extends State<UpdateDoctorDetails> {
  final _formsPageViewController = PageController();

  List _forms = [];
  TextEditingController _fname_controller = TextEditingController();
  TextEditingController _lname_controller = TextEditingController();
  TextEditingController _username_controller = TextEditingController();
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _dob_controller = TextEditingController();
  DateTime selectedBirthDate = DateTime.now().subtract(Duration(days: 6570));
  TextEditingController _specialized_in = TextEditingController();
  TextEditingController _year_of_exprience_controller = TextEditingController();
  TextEditingController _mobileno_controller = TextEditingController();
  TextEditingController _qualification_controller = TextEditingController();
  TextEditingController _description_controller = TextEditingController();
  TextEditingController _address_controller = TextEditingController();
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.highContrastLight(
                  primary: Color(0xff3b240e), // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Color(0xff3b240e), // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(primary: Color(0xff3b240e)))),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedBirthDate != null
            ? selectedBirthDate
            : DateTime.now().subtract(Duration(days: 6570)),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now().subtract(Duration(days: 6570)));
    if (picked != null && picked != selectedBirthDate) {
      _dob_controller.text = DateFormat('dd-MM-yyyy').format(picked).toString();
    }
  }

  var isLoading = false;
  String? selected_country_code;
  String? dropdownGender;
  String? role;
  List userRoleList = [
    {'id': 1, 'name': 'male'},
    {'id': 2, 'name': 'female'}
  ];
  Future _addNewUser() async {
    var user = await FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("profileUpdate").doc(user).update({
      'country_code': selected_country_code.toString().substring(1).toString(),
      'qualification': _qualification_controller.text,
      'dob': _dob_controller.text,
      'gender': dropdownGender.toString(),
      'email': _email_controller.text,
      'exprience': _year_of_exprience_controller.text,
      'lname': _lname_controller.text,
      'mobile_no': _mobileno_controller.text,
      'name': _fname_controller.text,
      'platform': 'web',
      'role_id': role.toString(),
      'user_name': _username_controller.text,
    }).catchError((e) {
      CommonMethods.showToast(e.toString());
      print("error $e");
    });

    // var responseJson = jsonDecode(response.body);
    // print(['message'].toString());
    //
    // if (responseJson['success'] == 1) {
    //   setState(() {
    //     print('user Added' + responseJson.toString());
    //     //print(responseJson['data'].toString());
    //     Fluttertoast.showToast(
    //         msg: "User Added",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 1);
    //
    //     Navigator.pop(context);
    //   });
    // } else if (responseJson['message'].toString() == 'Email Already Exits.') {
    //   print('Error' + responseJson['message'].toString());
    //   Fluttertoast.showToast(
    //       msg: "Email Already Exist",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.TOP,
    //       timeInSecForIosWeb: 1);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0xff3b240e),
                foregroundColor: Colors.black,
                automaticallyImplyLeading: false,
                excludeHeaderSemantics: true,
                titleSpacing: 0.0,
                title: LayoutBuilder(
                    builder: (BuildContext ctx, BoxConstraints constraints) {
                      if (constraints.maxWidth >= 480) {
                        return Container(
                          width: mediaQuery.width * 1,
                          height: mediaQuery.height * 0.1,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new_rounded),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(width: mediaQuery.width * 0.01),
                              Text('Add User 123',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: mediaQuery.width * 0.03,
                                  )),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.notifications_none_outlined,
                                    color: Colors.black,
                                    size: mediaQuery.width * 0.05),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Notifications(
                                  //       title: '',
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                              // CircleAvatar(
                              //     radius: 28,
                              //     backgroundColor: Colors.deepOrangeAccent,
                              //     child: (photo == 'noimage.jpg')
                              //         ? RichText(
                              //             text: TextSpan(
                              //                 text: box.read('user_name_initial'),
                              //                 style: TextStyle(fontSize: 25),
                              //                 recognizer: TapGestureRecognizer()
                              //                   ..onTap = () {
                              //                     Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                         builder: (context) =>
                              //                             LoginUserDetail(
                              //                                 title: ''),
                              //                       ),
                              //                     );
                              //                   }))
                              //         : GestureDetector(
                              //             onTap: () {
                              //               Navigator.push(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       LoginUserDetail(title: ''),
                              //                 ),
                              //               );
                              //             },
                              //             child: CircleAvatar(
                              //               radius: 25,
                              //               backgroundColor:
                              //                   Colors.deepOrangeAccent,
                              //               foregroundImage: NetworkImage(
                              //                   "https://work.hsmcontech.com/webapi/storage/app/public/user_photos/" +
                              //                       photo),
                              //               onForegroundImageError:
                              //                   (exception, context) {
                              //                 print(' Cannot be loaded');
                              //               },
                              //               child: RichText(
                              //                   text: TextSpan(
                              //                       text: box.read(
                              //                           'user_name_initial'),
                              //                       style: TextStyle(
                              //                           fontSize:
                              //                               mediaQuery.width *
                              //                                   0.05),
                              //                       recognizer:
                              //                           TapGestureRecognizer()
                              //                             ..onTap = () {
                              //                               Navigator.push(
                              //                                 context,
                              //                                 MaterialPageRoute(
                              //                                   builder: (context) =>
                              //                                       LoginUserDetail(
                              //                                           title:
                              //                                               ''),
                              //                                 ),
                              //                               );
                              //                             })),
                              //             ))),
                            ]),
                          ),
                        );
                      } else {
                        return Container(
                          width: mediaQuery.width * 1,
                          height: mediaQuery.height * 0.1,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new_rounded),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(width: mediaQuery.width * 0.01),
                              Text('Add User',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: mediaQuery.width * 0.04,
                                  )),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.notifications_none_outlined,
                                    color: Colors.black,
                                    size: mediaQuery.width * 0.08),
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Notifications(
                                  //       title: '',
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                              // CircleAvatar(
                              //     radius: mediaQuery.width * 0.055,
                              //     backgroundColor: Colors.deepOrangeAccent,
                              //     child: (photo == 'noimage.jpg')
                              //         ? RichText(
                              //             text: TextSpan(
                              //                 text: box.read('user_name_initial'),
                              //                 style: TextStyle(
                              //                     fontSize:
                              //                         mediaQuery.width * 0.06),
                              //                 recognizer: TapGestureRecognizer()
                              //                   ..onTap = () {
                              //                     Navigator.push(
                              //                       context,
                              //                       MaterialPageRoute(
                              //                         builder: (context) =>
                              //                             LoginUserDetail(
                              //                                 title: ''),
                              //                       ),
                              //                     );
                              //                   }))
                              //         : GestureDetector(
                              //             onTap: () {
                              //               Navigator.push(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       LoginUserDetail(title: ''),
                              //                 ),
                              //               );
                              //             },
                              //             child: CircleAvatar(
                              //               radius: 25,
                              //               backgroundColor:
                              //                   Colors.deepOrangeAccent,
                              //               foregroundImage: NetworkImage(
                              //                   "https://work.hsmcontech.com/webapi/storage/app/public/user_photos/" +
                              //                       photo),
                              //               onForegroundImageError:
                              //                   (exception, context) {
                              //                 print(' Cannot be loaded');
                              //               },
                              //               child: RichText(
                              //                   text: TextSpan(
                              //                       text: box.read(
                              //                           'user_name_initial'),
                              //                       style: TextStyle(
                              //                           fontSize:
                              //                               mediaQuery.width *
                              //                                   0.05),
                              //                       recognizer:
                              //                           TapGestureRecognizer()
                              //                             ..onTap = () {
                              //                               Navigator.push(
                              //                                 context,
                              //                                 MaterialPageRoute(
                              //                                   builder: (context) =>
                              //                                       LoginUserDetail(
                              //                                           title:
                              //                                               ''),
                              //                                 ),
                              //                               );
                              //                             })),
                              //             ))),
                            ]),
                          ),
                        );
                      }
                    })),
            body: Container(
              padding: EdgeInsets.all(mediaQuery.width * 0.03),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _fname_controller,
                          onEditingComplete: () => createEmail(),
                          decoration: const InputDecoration(
                              label: Text("First Name"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter First Name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _lname_controller,
                          onChanged: (content) {
                            setState(() {
                              // _username_controller = TextEditingController(text: _fname_controller.text + "."+ _lname_controller.text);
                              // _email_controller = TextEditingController(text: _fname_controller.text + "."+ _lname_controller.text + "@hsmedifice.com");
                              createEmail();
                            });
                          },
                          decoration: const InputDecoration(
                              label: Text("Last Name"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Last Name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          readOnly: true,
                          cursorColor: Color(0xff3b240e),
                          controller: _username_controller,
                          decoration: const InputDecoration(
                              label: Text("Username"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          //  onTap: () => createUsername(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _email_controller,
                          decoration: const InputDecoration(
                              label: Text("Email"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email id';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          showCursor: false,
                          keyboardType: TextInputType.none,
                          cursorColor: Color(0xff3b240e),
                          controller: _dob_controller,
                          decoration: const InputDecoration(
                              label: Text("Date of Birth"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _selectDateOfBirth(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select date';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _year_of_exprience_controller,
                          decoration: const InputDecoration(
                              label: Text("Year of exprience"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                        ),
                        Container(
                          child: IntlPhoneField(
                            controller: _mobileno_controller,
                            decoration: const InputDecoration(
                                label: Text(
                                  "Mobile No",
                                ),
                                floatingLabelStyle:
                                TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff3b240e)))),

                            initialCountryCode:
                            'IN', //default contry code, NP for Nepal
                            onChanged: (phone) {
                              setState(() {
                                selected_country_code = phone.countryCode;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Mobile No';
                              }
                              return null;
                            },
                          ),
                        ),
                        TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _qualification_controller,
                          decoration: const InputDecoration(
                              label: Text("Qualification"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Qualification';
                            }
                            return null;
                          },
                        ),            TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _description_controller,
                          decoration: const InputDecoration(
                              label: Text("Description"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Description';
                            }
                            return null;
                          },
                        ),       TextFormField(
                          cursorColor: Color(0xff3b240e),
                          controller: _address_controller,
                          decoration: const InputDecoration(
                              label: Text("Address"),
                              floatingLabelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff3b240e)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                        ),
                        Container(
                          child: DropdownButtonFormField<String>(
                            value: dropdownGender,
                            hint: const Text(
                              'Select Gender',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (String? newValue) => setState(() {
                              dropdownGender = newValue!;
                              role = dropdownGender.toString();
                            }),
                            validator: (value) =>
                            value == null ? 'Select Gender' : null,
                            items: userRoleList.map((value) {
                              return DropdownMenuItem<String>(
                                value: value['id'].toString(),
                                child: Text(value['name']),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                                label: Text("Gender"),
                                floatingLabelStyle:
                                TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff3b240e)))),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            bottomNavigationBar: Material(
              color: const Color(0xff3b240e),
              child: SizedBox(
                height: SizeConfig.hM! * 7.0,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      if (_formKey.currentState!.validate()) {
                        _addNewUser();
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    }
                    isLoading = false;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.hM! * 1.5,
                        vertical: SizeConfig.hM! * 1.5),
                    decoration: BoxDecoration(
                        color: Color(0xff3b240e),
                        borderRadius:
                        BorderRadius.circular(SizeConfig.hM! * 1.0)),
                    child: isLoading
                        ? Container(
                      width: SizeConfig.hM! * 14.0,
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.hM! * 1.4),
                      child: const LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black26,
                      ),
                    )
                        : Text(
                      "Add",
                      style: TextStyle(
                          fontSize: SizeConfig.hM! * 2.2,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void createEmail() {
    var a = _fname_controller.text.toLowerCase();
    var b = _lname_controller.text.toLowerCase();
    if (!a.toString().isEmpty && !b.toString().isEmpty) {
      setState(() {
        _username_controller = TextEditingController(
            text: _fname_controller.text + "." + _lname_controller.text);
        _email_controller = TextEditingController(
            text: _fname_controller.text.toLowerCase() +
                "." +
                _lname_controller.text.toLowerCase() +
                "@hsmedifice.com");
      });
    } else if (!a.toString().isEmpty || !b.toString().isEmpty) {
      _username_controller.clear();
      _email_controller.clear();
    } else {
      _username_controller.clear();
      _email_controller.clear();
    }
  }

  bool onWillPop() {
    if (_formsPageViewController.page?.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    return false;
  }
}
