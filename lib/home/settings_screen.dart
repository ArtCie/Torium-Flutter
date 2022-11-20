import 'package:flutter/material.dart';
import '../authentication/amplify.dart';
import '../user_first_login/organizations/organization_screen.dart';
import '../user_first_login/preferences_screen.dart';
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
      if (result != null) {
        widget.userId = result;
        await GetUserPreferences(result).fetch().then((result) {
          var data = result["data"];
          List<SettingType> newList = [];
          newList.add(getSettingTypeByName("Email", data));
          newList.add(getSettingTypeByName("Notifications Preferences", data));
          newList.add(getSettingTypeByName("Bank", data));

          setState(() {
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
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader("Groups", alignment: Alignment.centerLeft),
              Expanded(child:
              settingTypes.isNotEmpty ? getPreferencesWidget() : LoadingScreen.getScreen()
              ),
            ]
        ),
      ),
    );
  }

  ListView getPreferencesWidget() {
    return ListView.builder(
      itemCount: settingTypes.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 100,
            child: ListTile(
                leading: settingTypes[index].icon,
                title: Text(settingTypes[index].name),
                subtitle: Text(settingTypes[index].value),
                trailing: settingTypes[index].name != "Email" ? const Icon(
                    IconData(0xf8f5, fontFamily: 'MaterialIcons',
                        matchTextDirection: true),
                    color: Color.fromRGBO(35, 54, 92, 0.5)
                ) : null,
                onTap: settingTypes[index].name != "Email" ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => settingTypes[index].defaultAction),
                    );
                } : null // Handle your onTap here.
              ),
          ),
        );
      },
    );
  }

  SettingType getSettingTypeByName(String name, Map<dynamic, dynamic> data) {
    Icon icon = getIconByName(name);
    String value = getValueByName(name, data);
    var action = getActionByName(name, data);
    int? id = (name == "Bank") ? data["organization_id"] : null;
    return SettingType(
        name: name, icon: icon, value: value, defaultAction: action, id: id);
  }

  Icon getIconByName(String name) {
    switch (name) {
      case "Email":
        return const Icon(
          IconData(0xf705, fontFamily: 'MaterialIcons'),
          color: Color.fromRGBO(35, 54, 92, 0.5),
          size: 35,
        );
      case "Notifications Preferences":
        return const Icon(
          IconData(0xe44f, fontFamily: 'MaterialIcons'),
          color: Color.fromRGBO(35, 54, 92, 0.5),
          size: 35,
        );
      default:
        return const Icon(
          IconData(0xf58f, fontFamily: 'MaterialIcons'),
          color: Color.fromRGBO(35, 54, 92, 0.5),
          size: 35,
        );
    }
  }

  String getValueByName(String name, Map<dynamic, dynamic> data) {
    switch (name) {
      case "Email":
        return data["email"];
      case "Notifications Preferences":
        return data["reminder_preferences"];
      default:
        return data["organization_name"];
    }
  }

  getActionByName(String name, var data) {
    switch (name) {
      case "Email":
        return null;
      case "Notifications Preferences":
        return PreferencesScreen(value: data["reminder_preferences"] == "EMAIL" ? "Email": data["reminder_preferences"], input: "settings");
      default:
        return OrganizationScreen(widget.userId, currentId: data["organization_id"], inputMethod: "settings",);
    }
  }
}

class SettingType{
  String name;
  Icon icon;
  String value;
  var defaultAction;
  int? id;

  SettingType({required this.name, required this.icon, required this.value, required this.defaultAction, this.id});
}