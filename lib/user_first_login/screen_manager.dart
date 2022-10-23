import '../autentication/amplify.dart';
import 'package:flutter/material.dart';
import '../home/home.dart';
import '../home/loading_screen.dart';
import '../api/users/get_user_preferences.dart';
import 'package:flutter/services.dart';
import '../user_first_login/organizations/organization_screen.dart';
import '../utils.dart';

class ScreenManager extends StatefulWidget {
  String userId = "";
  Scaffold currentPage = LoadingScreen.getScreen();
  Map <String, dynamic> screens = {
    "null": 1,
  };
  Map<dynamic, dynamic> data = {};

  ScreenManager({super.key});

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  _ScreenManagerState();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    widget.userId = (await AmplifyConfigure.getUserId())!;
    getUserPreferences().then((data) {
      setState(() {
        if(data["data"]["reminder_preferences"] == null){
          Navigator.pushReplacementNamed(context, '/preferences');
        }
        else if(data["data"]["organization_id"] == null){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OrganizationScreen(widget.userId),
              ));
        }
        else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(widget.userId),
              ));
        }
      });
    });
  }

  Future<Map> getUserPreferences() async {
    GetUserPreferences getUserPreferences = GetUserPreferences(widget.userId);
    Map<dynamic, dynamic> fetchedData = await getUserPreferences.fetch();
    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar().get(isProfile: false),
      body: SafeArea(child: widget.currentPage),
    );
  }
}
