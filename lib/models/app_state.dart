import 'package:flutter/foundation.dart';
import '../utilities/constants.dart';

class AppState extends ChangeNotifier {

  String name = '';

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

  setupStages setUpStage = setupStages.nameStage;

  void setSetupStage(setupStages setUpStage){
    this.setUpStage = setUpStage;
    notifyListeners();
  }

  bool bioLockEnabled = false;

  void setBioLock(bool bioLockEnabled) {
    this.bioLockEnabled = bioLockEnabled;
    notifyListeners();
  }

}