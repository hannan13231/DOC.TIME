import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_projects/utils/size_config.dart';

class ActionButton extends StatefulWidget {

  final String txt;
  final double hPadding;// horizontal padding
  final double hMargin , vMargin;//// horizontal padding
  final Function? action;

  ActionButton({required this.txt,
    this.hPadding = 0.0, this.hMargin = 0.0,this.vMargin = 0.0, this.action ,});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async {
        isLoading = true;
        setState(() {});
        try{
          if(widget.action != null) {
            await widget.action!();
          }
        }catch (e){
          if (kDebugMode) {
            print(e.toString());
          }
        }
        isLoading = false;
        if(mounted) {
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: widget.hPadding , vertical: SizeConfig.hM! * 1.5
        ),
        margin: EdgeInsets.symmetric(horizontal: widget.hMargin , vertical: widget.vMargin),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(SizeConfig.hM! * 1.0)
        ),
        child: isLoading ? Container(
          width: SizeConfig.hM! * 14.0,
          padding: EdgeInsets.symmetric(
            //horizontal: SizeConfig.hM! * 14.0,
            vertical: SizeConfig.hM! * 1.4
          ),
          child: const LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.black26,
          ),
        ) : Text(widget.txt , style: TextStyle(
          fontSize: SizeConfig.hM! * 2.2,
          fontWeight: FontWeight.w500,
          color: Colors.white
        ),),
      ),
    );
  }
}
