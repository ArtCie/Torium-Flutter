class Member{
  final int _userId;
  final String _email;
  final String _status;

  Member(this._userId, this._email, this._status);

  int get userId => _userId;

  String get email => _email;

  String get status => _status;
}