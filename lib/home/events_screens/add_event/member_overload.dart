import '../../content/member.dart';

class MemberOverload extends Member{
  bool _isChosen;

  MemberOverload(int userId, String email, String status, {bool isChosen = true}) :
        _isChosen = isChosen,
        super(userId, email, status);

  bool get isChosen => _isChosen;

  set isChosen(newStatus) => _isChosen = newStatus;
}