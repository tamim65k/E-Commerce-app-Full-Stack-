import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    password: '',
    email: '',
    address: '',
    type: '',
    token: '',
  );

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
