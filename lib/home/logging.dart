import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import '../authentication/amplify.dart';
import '../utils.dart';
import 'loading_screen.dart';

class Logging extends StatefulWidget {
  const Logging({Key? key}) : super(key: key);

  @override
  State<Logging> createState() => _LoggingState();
}

class _LoggingState extends State<Logging> {
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    var userAttributes = await AmplifyConfigure.getUserAttribute();
    for (var attributes in userAttributes) {
      if (attributes.userAttributeKey ==
          const CognitoUserAttributeKey.custom('custom:user_id')) {
        setState(() {
          userId = attributes.value;
          Navigator.pushReplacementNamed(context, '/first_login', arguments: {'userId': attributes.value});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            'Torium',
            style: TextStyle(
                letterSpacing: 5, fontSize: 20, color: Colors.black87),
          ),
        ]),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
              icon: const Icon(
                IconData(0xf522, fontFamily: 'MaterialIcons'),
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {},
            ),
          )
        ],
        backgroundColor: DefaultColors.getDefaultColor(),
      ),
      body: SafeArea(child: LoadingScreen.getScreen()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                  IconData(0xe2eb, fontFamily: 'MaterialIcons')
              ),
              label: 'Groups',),
          BottomNavigationBarItem(
              icon: Icon(
                  IconData(0xe23e, fontFamily: 'MaterialIcons')
              ),
              label: 'Events')
        ],
        backgroundColor: DefaultColors.getDefaultColor(),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.black87,
      ),
    );
  }
}
