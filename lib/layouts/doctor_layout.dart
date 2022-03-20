import 'package:flutter/material.dart';
import 'package:new_projects/models/user_model.dart';
import 'package:new_projects/screens/doctor_profile_screen.dart';
import 'package:new_projects/utils/common_methods.dart';
import 'package:new_projects/utils/size_config.dart';

class DoctorLayout extends StatelessWidget {

  final UserModel? userModel;

  const DoctorLayout({this.userModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        CommonMethods.navigateTo(context, DoctorProfileScreen(userModel));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.hM! * 1.0
        ),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.hM! * 1.0,
          horizontal: SizeConfig.hM! * 1.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.2),
          boxShadow:  [
            BoxShadow(
              color: Colors.white.withOpacity(0.4),
              blurRadius: 2.0,
              spreadRadius: 2.0,
            )
          ]
        ),
        child: Row(
          children: [

            CircleAvatar(
              backgroundImage: const AssetImage("assets/images/doctor.png"),
              radius: SizeConfig.hM! * 3.5,
            ),

            SizedBox(width: SizeConfig.iM! * 2.0,),
            Expanded(
              child: RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: "${userModel?.userName}",
                          style: TextStyle(
                              fontSize: SizeConfig.hM! * 2.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      TextSpan(
                          text: userModel?.specialist!=null?"\n${userModel?.specialist}":"\nGynaec",
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
      ),
    );
  }
}
