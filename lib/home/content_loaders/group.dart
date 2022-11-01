class Group{
  final int _adminId;
  final int _groupId;
  final String _name;
  final String _status;

  Group(this._adminId, this._groupId, this._name, this._status);

  int get adminId => _adminId;

  int get groupId => _groupId;

  String get status => _status;

  String get name => _name;
}