import '../../content/member.dart';

class MemberOverload extends Member{
  bool _isChosen = true;

  MemberOverload(int userId, String email, String status) : super(userId, email, status);

  bool get isChosen => _isChosen;

  set isChosen(newStatus) => _isChosen = newStatus;
}