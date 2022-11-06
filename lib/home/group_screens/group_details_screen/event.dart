import 'package:intl/intl.dart';

class Event{
  late String _name;
  late String _description;
  late String _datetime;

  Event(String name, String description, String datetime) {
    _name = name;
    _description = description;
    var datetimeParsed = DateTime.parse(datetime);
    _datetime = DateFormat('dd MMM yyyy h:mm a').format(datetimeParsed);

  }

  String get name => _name;

  String get description => _description;

  String get datetime => _datetime;
}