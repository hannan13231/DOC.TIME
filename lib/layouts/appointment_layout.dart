import 'package:flutter/material.dart';
import 'package:new_projects/models/user_model.dart';
import 'package:new_projects/utils/size_config.dart';

class AppointmentLayout extends StatelessWidget {
  final AppointmentModel? appointmentModel;
   AppointmentLayout({this.appointmentModel,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.2),
        color: Colors.orangeAccent,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.iM! * 4.0,
        vertical: SizeConfig.hM! * 1.0,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        text: appointmentModel!.userName,
                        style: TextStyle(
                          fontSize: SizeConfig.hM! * 2.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                          text: "\n${appointmentModel!.specialist}",
                        style: TextStyle(
                          fontSize: SizeConfig.hM! * 1.6,
                          color: Colors.black45,

                        )
                      ),
                    ]
                  ),
                ),
              )

            ],
          ),

          //date time
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
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.5)
            ),
            child: Column(
              children: [
                Row(
                  children: [

                    _dateTimeItem( appointmentModel!.date.toString()),
                    SizedBox(width: SizeConfig.iM! * 1.0 ,),
                    // _dateTimeItem("11:00 - 12:00 AM"),

                  ],
                ),
                SizedBox(height: SizeConfig.hM! * 2.0,),

                Row(
                  children: [
                    _dateTimeItem(appointmentModel!.address.toString()),
                  ],
                ),
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
}
