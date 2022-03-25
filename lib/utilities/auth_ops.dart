import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthOps {
  //class Auth Operations

  late final SharedPreferences _sharedPreferences;

  open() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> setUser(User user) async {
    return await _sharedPreferences.setString('auth', jsonEncode(user.toMap()));
  }

  User getUser() {
    try{
      return User.fromMap(jsonDecode(_sharedPreferences.getString('auth')!));
    } catch(e){
      return User(firstName: '', hasBiometricLock: false);
    }
  }
}