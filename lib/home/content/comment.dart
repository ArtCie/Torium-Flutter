
class Comment{
  late String _comment;
  late String _id;
  late String _relativeTime;
  late String _userId;

  Comment(String comment, String id, String userId, String relativeTime) {
    _comment = comment;
    _id = id;
    _userId = userId;
    _relativeTime = relativeTime;
  }

  String get comment => _comment;

  String get id => _id;

  String get userId => _userId;

  String get relativeTime => _relativeTime;

  set comment(String comment) {
    _comment = comment;
  }
}