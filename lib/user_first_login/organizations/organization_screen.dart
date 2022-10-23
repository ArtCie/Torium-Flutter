import 'package:flutter/material.dart';
import '../../../api/organizations/get_organizations.dart';
import '../../../api/organizations/patch_organization.dart';
import '../../home/home.dart';
import '../../home/loading_screen.dart';
import '../../utils.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen(this.userId, {super.key});

  final String userId;

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {

  List<Organization> organizationList = [];
  int ?currentId;

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
      appBar: DefaultAppBar().get(isProfile: false),
      body: SafeArea(child: (organizationList == []) ? LoadingScreen.getScreen() : getOrganizationScreen()),
    );
  }

  Widget customButton(String text) {
    return SizedBox(
      height: 70.0,
      width: 150.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: (text == "Skip" || (text == "Continue" && currentId != null)) ? Colors.teal[200] : Colors.grey, //<-- SEE HERE
        ),
        onPressed: text == "Skip" || (text == "Continue" && currentId != null) ? () {
          if(currentId != null){
            PatchOrganization(widget.userId, currentId).fetch();
          }
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(widget.userId),
              ));

        } : null ,
        child: Text(text,
            style: TextStyle(
              color: Colors.grey[800],
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
                Text(
                  "Choose your bank",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
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
      backgroundColor: Colors.grey[300],
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
          backgroundColor: (currentId == organization.id) ? Colors.teal[100]: Colors.grey[300], //<-- SEE HERE
        ),
        onPressed: () {
          setState(() {
            currentId = organization.id;
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