import 'package:flutter/material.dart';
import 'package:torium/user_first_login/mobile/mobile_number_init.dart';
import '../authentication/amplify.dart';
import '../utils.dart';
import '../api/users/patch_preferences.dart';
import 'organizations/organization_screen.dart';


class PreferencesScreen extends StatefulWidget {
  String userId = "";
  String value;
  String input;
  PreferencesScreen({super.key, this.value = "Email", this.input = "first_login"});

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<PreferencesScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AmplifyConfigure.getUserId().then((result) {
      if(result != null) {
        widget.userId = result;
      }
    });
}
  Widget customRadioButton(String text) {
    return SizedBox(
      height: 60.0,
      width: 200.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: (widget.value == text) ? DefaultColors.getDefaultColor(): Colors.grey[50],
        ),
        onPressed: () {
          setState(() {
            widget.value = text;
          });
        },
        child: Text(
          text,
          style: TextStyle(
              color: (widget.value == text) ? Colors.white : Colors.grey[800],
              fontSize: 15,
              fontWeight: (widget.value == text) ? FontWeight.bold : FontWeight.normal,
          )
        ),
      )
    );
  }

  Widget continueButton(){
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: DefaultColors.getDefaultColor()
        ),
        onPressed: () {
            String valueUpper = widget.value.toUpperCase();
            switch (valueUpper) {
              case "SMS":
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      MobileNumberInit(inputMethod: widget.input)));
                break;
              case "EMAIL":
                PatchPreferences(widget.userId, "EMAIL").fetch();
                if(widget.input == "settings"){
                  Navigator.pop(context);
                }
                else{
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OrganizationScreen(widget.userId),
                      ));
                }
                break;
              case "PUSH":
                PatchPreferences(widget.userId, "PUSH").fetch();
                if(widget.input == "settings"){
                  Navigator.pop(context);
                }
                else{
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OrganizationScreen(widget.userId),
                      ));
                }
            }
        },
        child: const Text(
            "Continue",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
                child: Text(
                    "Choose notification type: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 30)
                ),
              ),
              const SizedBox(height: 80),
              customRadioButton("Email"),
              const SizedBox(height: 40),
              customRadioButton("SMS"),
              const SizedBox(height: 40),
              customRadioButton("PUSH"),
              const SizedBox(height: 50),
              continueButton()
            ]
        ),
      ),
    );
  }
}
