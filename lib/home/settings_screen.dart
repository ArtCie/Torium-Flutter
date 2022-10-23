import 'package:flutter/material.dart';
import '../autentication/amplify.dart';
import '../utils.dart';
import '../../api/users/get_user_preferences.dart';
import 'loading_screen.dart';


class SettingsScreen extends StatefulWidget {
  String userId = "";
  SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<SettingType> settingTypes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    await AmplifyConfigure.getUserId().then((result) async {
      if(result != null) {
        widget.userId = result;
        await GetUserPreferences(result).fetch().then((result) {
          var data = result["data"];
          List<SettingType> newList = [];
          newList.add(getSettingTypeByName("Email", data));
          newList.add(getSettingTypeByName("Notifications Preferences", data));
          newList.add(getSettingTypeByName("Bank", data));

          setState(() {
            print(settingTypes);
            settingTypes = newList;
          });
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar().get(isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
                child: Text(
                    "User profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 25)
                ),
              ),
              Expanded(child:
                settingTypes.isNotEmpty ? getPreferencesWidget() : LoadingScreen.getScreen()
              ),
            ]
        ),
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  ListView getPreferencesWidget() {
    print(settingTypes);
    return ListView.builder(
      itemCount: settingTypes.length,
      itemBuilder: (_, index) {
        return SizedBox(
          height: 120,
          child: Card(
              child: Container(
                alignment: Alignment.centerLeft,
                child: ListTile(
                leading: settingTypes[index].icon,
                title: Text(settingTypes[index].name),
                subtitle: Text(settingTypes[index].value),
                trailing: settingTypes[index].name != "Email" ? const Icon(
                    IconData(0xf8f5, fontFamily: 'MaterialIcons', matchTextDirection: true)
                ) : null,
                onTap: () {}, // Handle your onTap here.
            ),
              )
          ),
        );
      },
    );
  }

  SettingType getSettingTypeByName(String name, Map<dynamic, dynamic> data){
    Icon icon = getIconByName(name);
    String value = getValueByName(name, data);
    return SettingType(name: name, icon: icon, value: value);
  }

  Icon getIconByName(String name){
    switch(name){
      case "Email":
        return const Icon(
          IconData(0xf705, fontFamily: 'MaterialIcons'),
          size: 35,
        );
      case "Notifications Preferences":
        return const Icon(
          IconData(0xe44f, fontFamily: 'MaterialIcons'),
          size: 35,
        );
      default:
        return const Icon(
          IconData(0xf58f, fontFamily: 'MaterialIcons'),
          size: 35,
        );
    }
  }

  String getValueByName(String name, Map<dynamic, dynamic> data) {
    switch(name){
      case "Email":
        return data["email"];
      case "Notifications Preferences":
        return data["reminder_preferences"];
      default:
        return data["organization_name"];
    }
  }
}

class SettingType{
  String name;
  Icon icon;
  String value;

  SettingType({required this.name, required this.icon, required this.value});
}