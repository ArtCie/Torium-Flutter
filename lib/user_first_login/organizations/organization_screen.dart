import 'package:flutter/material.dart';
import '../../../api/organizations/get_organizations.dart';
import '../../../api/organizations/patch_organization.dart';
import '../../home/home.dart';
import '../../home/loading_screen.dart';
import '../../utils.dart';

class OrganizationScreen extends StatefulWidget {
  OrganizationScreen(this.userId,  {super.key, this.currentId, this.inputMethod = "first_login"});

  int? currentId;
  final String userId;
  String inputMethod;

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {

  List<Organization> organizationList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    GetUserPreferences().fetch().then((data) {
      setState(() {
        for (var organization in data["data"]) {
          organizationList.add(Organization(
              organization["id"], organization["logo_link"],
              organization["name"], organization["url"]));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: SafeArea(child: (organizationList == []) ? LoadingScreen.getScreen() : getOrganizationScreen()),
    );
  }

  Widget customButton(String text) {
    return SizedBox(
      height: 70.0,
      width: 150.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: (text == "Skip" || (text == "Continue" && widget.currentId != null)) ? DefaultColors.getDefaultColor() : Colors.grey,
        ),
        onPressed: text == "Skip" || (text == "Continue" && widget.currentId != null) ? () {
          if(widget.currentId != null){
            PatchOrganization(widget.userId, widget.currentId).fetch();
          }
          if(widget.inputMethod == "settings"){
            Navigator.pop(context);
          }
          else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          }

        } : null ,
        child: Text(text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

  Widget getOrganizationScreen() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
              children: <Widget>[
                const Text(
                  "Choose your bank",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                const SizedBox(height: 40),
                getOrganizations(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  customButton("Continue"),
                  customButton("Skip"),
                ]
                )
              ]),
        ),
      ),
    );
  }

  Widget getOrganizations() {
    return Flexible(
      child: GridView.count(
        childAspectRatio: 0.9,
        crossAxisCount: 2,
        children: <Widget>[
          for(var organization in organizationList) insertOrganization(organization)
        ],
      ),
    );
  }

  insertOrganization(Organization organization) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: (widget.currentId == organization.id) ? DefaultColors.getDefaultColor(opacity: 0.2): Colors.white,
        ),
        onPressed: () {
          setState(() {
            widget.currentId = organization.id;
          });
        },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(organization.name),
                Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(organization.logoLink),
                      fit: BoxFit.scaleDown,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                )
              ]
          ),
      ),
    );
  }
}


class Organization{
  int id;
  String logoLink;
  String name;
  String url;

  Organization(this.id, this.logoLink, this.name, this.url);
}