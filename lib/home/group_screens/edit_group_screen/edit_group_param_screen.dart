
import 'package:flutter/material.dart';

import '../../../utils.dart';
import '../../content/event.dart';

class EditParamScreen extends StatefulWidget {
  String parameterName;
  String parameterValue;
  EditParamScreen({super.key, required this.parameterName, required this.parameterValue});

  @override
  _EditParamScreenState createState() => _EditParamScreenState();
}

class _EditParamScreenState extends State<EditParamScreen> {
  List<Event> groupEvents = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController paramEditController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader(widget.parameterName),
              Expanded(
                  child: buildAddGroupWidget()
              )
            ]
        ),
      ),
    );
  }

  Widget buildAddGroupWidget() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildTextFormField(),
            const SizedBox(height: 70),
            buildContinueButton(),
          ],
        ),

      ),
    );
  }

  TextFormField buildTextFormField() {
    paramEditController.text = widget.parameterValue;
    return TextFormField(
        controller: paramEditController,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            border: OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: Colors.white
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        }
    );
  }

  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: Colors.teal[300]),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, paramEditController.text);
          }
        },
        child: const Text("Save!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

}

