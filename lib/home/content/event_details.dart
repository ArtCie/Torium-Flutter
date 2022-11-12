import 'package:intl/intl.dart';

class EventDetails{
  late String _name;
  late String _description;
  late DateTime _datetime;
  late var _budget;
  late int _groupId;
  late String _groupName;
  late bool _isBudget;
  late String _reminder;
  late String _schedulePeriod;
  late List<dynamic> _users;

  EventDetails(String name, String description, String datetime, var budget,
      int groupId, String groupName, bool isBudget, String reminder, String schedulePeriod,
      List<dynamic> users) {
    _name = name;
    _description = description;
    _datetime = DateTime.parse(datetime);
    // _datetime = DateFormat('dd MMM yyyy h:mm a').format(datetimeParsed);
    _budget = budget;
    _groupId = groupId;
    _groupName = groupName;
    _isBudget = isBudget;
    _reminder = reminder;
    _schedulePeriod = schedulePeriod;
    _users = users;
  }

  String get name => _name;

  String get description => _description;

  DateTime get datetime => _datetime;

  get budget => _budget;

  int get groupId => _groupId;

  String get groupName => _groupName;

  bool get isBudget => _isBudget;

  String get reminder => _reminder;

  String get schedulePeriod => _schedulePeriod;

  List<dynamic> get users => _users;
}