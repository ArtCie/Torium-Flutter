import 'package:flutter/material.dart';
import '../../api/users/patch_update_mobile_phone.dart';
import 'package:code_input/code_input.dart';

import '../../home/home.dart';
import '../../utils.dart';

class MobileNumberSubmitCode extends StatefulWidget {
  MobileNumberSubmitCode(this.userId, this.mobileNumber, {super.key, this.inputMethod = "first_login"});

  final String userId;
  final String mobileNumber;
  String inputMethod;

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
      appBar: DefaultWidgets().get(isProfile: false),
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
                _buildCodeInput(),
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
            _checkCode();
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

  Widget _buildCodeInput() {
    return CodeInput(
      length: 6,
      keyboardType: TextInputType.number,
      builder: CodeInputBuilders.rectangle(
          border: const Border(),
          color: (Colors.teal[100])!,
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 30
          )
      ),
      spacing: 8,
      onChanged: (value) => setState(() {
        _code = value;
      }),
    );
  }

  void _checkCode(){
    PatchUpdateMobilePhone(widget.userId, _code).fetch().then((result) {
      if(result["status"]["code"].toString() == "200"){
        if(widget.inputMethod == "settings") {
          var nav = Navigator.of(context);
          nav.pop();
          nav.pop();
          nav.pop();
        }
        else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong confirmation code!')
        ));
      }
    });
  }
}

