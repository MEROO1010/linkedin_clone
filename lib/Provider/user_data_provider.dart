import 'package:flutter/cupertino.dart';
import 'package:linkedin_clone/Models/user_model.dart';
import 'package:linkedin_clone/services/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserData get getUser => _user!;

  Future<void> refreshUser() async {
    UserData user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
