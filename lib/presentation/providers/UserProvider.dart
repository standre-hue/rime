import 'package:flutter/material.dart';
import 'package:rime/data/models/User.dart';

class UserProvider with ChangeNotifier {
  late User _user;
  List<User> _users =  [];

  User get user => _user;
  List<User> get users => _users;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
    void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }
}
