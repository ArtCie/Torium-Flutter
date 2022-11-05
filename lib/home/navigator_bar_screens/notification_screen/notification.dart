class UserNotification{
  final String _email;
  final int _groupId;
  final String _name;

  UserNotification(this._email, this._groupId, this._name);

  String get email => _email;

  int get groupId => _groupId;

  String get name => _name;

}