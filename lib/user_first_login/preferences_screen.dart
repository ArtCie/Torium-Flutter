import 'package:flutter/material.dart';
import '../autentication/amplify.dart';
import '../utils.dart';
import '../api/users/patch_preferences.dart';
import 'organizations/organization_screen.dart';


class PreferencesScreen extends StatefulWidget {
  String userId = "";
  PreferencesScreen({super.key});

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

  String value = "Email";
  Widget customRadioButton(String text) {
    return SizedBox(
      height: 60.0,
      width: 200.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: (value == text) ? Colors.teal[100]: Colors.grey[300], //<-- SEE HERE
        ),
        onPressed: () {
          setState(() {
            value = text;
          });
        },
        child: Text(
          text,
          style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: (value == text) ? FontWeight.bold : FontWeight.normal,
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
          backgroundColor: Colors.teal[300]
        ),
        onPressed: () {
            String valueUpper = value.toUpperCase();
            switch (valueUpper) {
              case "SMS":
                Navigator.pushNamed(context, "/mobile_number_init");
                break;
              case "EMAIL":
                PatchPreferences(widget.userId, "EMAIL").fetch();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OrganizationScreen(widget.userId),
                    ));
                break;
              case "PUSH":
                break;
            }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const SecondRoute()),
            // );
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
      appBar: DefaultAppBar.get(isProfile: false),
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
      backgroundColor: Colors.grey[300],
    );
  }
}
