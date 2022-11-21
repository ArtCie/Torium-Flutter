import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_number/phone_number.dart';
import '../../authentication/amplify.dart';
import 'mobile_number_submit_code.dart';

import '../../utils.dart';

class MobileNumberInit extends StatefulWidget {
  MobileNumberInit({super.key, this.inputMethod = "first_login"});

  String inputMethod;

  @override
  State<MobileNumberInit> createState() => _MobileNumberInitState();
}

class _MobileNumberInitState extends State<MobileNumberInit> {
  String phoneNumber = "";
  String userId = "TEST";
  bool isValid = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AmplifyConfigure.getUserId().then((result) {
      userId = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter phone number:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(height: 40),
                phoneNumberForm(),
                const SizedBox(height: 40),
                continueButton()
              ]),
        ),
      ),
    );
  }

  Widget phoneNumberForm() {
    return IntlPhoneField(
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'PL',
      onChanged: (phone) async {
        phoneNumber = phone.completeNumber;
        try{
          await PhoneNumberUtil().validate(phone.completeNumber, regionCode: phone.countryCode);
          setState(() {
            isValid = phone.number.length == 9 ? true : false;
          });
        }
        catch(e){
          setState(() {
            isValid = false;
          });
        }
      },
    );
  }

  Widget continueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: isValid ?
        DefaultColors.getDefaultColor() : Colors.grey[400]),
        onPressed: isValid ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MobileNumberSubmitCode(userId, phoneNumber, inputMethod: widget.inputMethod)),
          );
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
