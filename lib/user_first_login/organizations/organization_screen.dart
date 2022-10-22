import 'package:flutter/material.dart';
import '../../api/users/patch_update_mobile_phone.dart';
import 'package:code_input/code_input.dart';

import '../../utils.dart';

class MobileNumberSubmitCode extends StatefulWidget {
  const MobileNumberSubmitCode(this.userId, this.mobileNumber, {super.key});

  final String userId;
  final String mobileNumber;

  @override
  State<MobileNumberSubmitCode> createState() => _MobileNumberSubmitCodeState();
}

class _MobileNumberSubmitCodeState extends State<MobileNumberSubmitCode> {

  bool isValid = false;
  String? _code;

  @override
  void initState() {
    super.initState();
    // PostMobilePhoneUpdate(widget.userId, widget.mobileNumber).fetch(); # TODO włączyć to
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar.get(isProfile: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter confirmation code:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(height: 40),

                const SizedBox(height: 40),
                continueButton()
              ]),
        ),
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  Widget continueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: _code?.length == 6 ?
        Colors.teal[300] : Colors.grey[400]),
        onPressed: _code?.length == 6 ? () {
          print("TESTING");
        } : null,
        child: const Text("Continue",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

}

