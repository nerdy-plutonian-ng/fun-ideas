import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {

  String name = '';

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

}