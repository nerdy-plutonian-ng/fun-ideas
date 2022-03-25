import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import '../routes/home_page.dart';
import '../utilities/constants.dart';
import '../models/user.dart';
import '../utilities/auth_ops.dart';
import '../utilities/utils.dart' show showSnackBar;

class SetupWidget extends StatefulWidget {
  const SetupWidget({Key? key}) : super(key: key);

  @override
  State<SetupWidget> createState() => _SetupWidgetState();
}

class _SetupWidgetState extends State<SetupWidget> {
  var isBiometricLockEnabled = false;
  final firstNameTEC = TextEditingController();
  String? firstNameError;
  var hasBioAuth = false;

  void onChangeEnableBiometricLock(bool? value){
    setState(() {
      isBiometricLockEnabled = value!;
    });
  }

  void onTapEnableBiometricLock(){
    setState(() {
      isBiometricLockEnabled = !isBiometricLockEnabled;
    });
  }

  void showSuccess() {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (_){
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 192,
              child: Lottie.asset('assets/animations/success'
                  '.json'),
            ),
            OutlinedButton(onPressed: (){
              Navigator.pushNamed(context, HomePage.routeName);
            }, child: const Text('You\'re in!'))
          ],
        ),),
      );
    });
  }

  void checkBioAuthAvailability() async {
    var localAuth = LocalAuthentication();
    bool canCheckBiometrics =
        await localAuth.canCheckBiometrics;
    setState(() {
      hasBioAuth = canCheckBiometrics;
    });
  }

  void completeSetup () async {
    if(firstNameTEC.text.isEmpty){
      setState(() {
        firstNameError = 'Your first name is required!';
      });
      return;
    }

    final newUser = User(firstName: firstNameTEC.text, hasBiometricLock: isBiometricLockEnabled);
    final authOps = AuthOps();
    await authOps.open();
    if(await authOps.setUser(newUser)){
      showSuccess();
      return;
    }
    showSnackBar(context: context, message: 'Failed setting up user, try again!!!',
        error: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children : [
            Text(appName,style: Theme.of(context).textTheme.headlineLarge,),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0,bottom: 16),
              child: Text('Setup',style: Theme.of(context).textTheme
                  .headlineSmall,),
            ),
            TextField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: firstNameTEC,
              onChanged: (text){
                setState(() {
                  firstNameError = null;
                });
                if(text.contains(' ')){
                  setState(() {
                    firstNameTEC.text = text.split(' ').first;
                  });
                  showSnackBar(context: context, message: 'Just your first name',error: true);
                }
              },
              decoration: InputDecoration(
                label: const Text('First Name'),
                errorText: firstNameError
              ),
            ),
            Visibility(
              visible: hasBioAuth,
              child: ListTile(
                onTap: onTapEnableBiometricLock,
                leading: Checkbox(value: isBiometricLockEnabled, onChanged:
                  onChangeEnableBiometricLock,),title: const Text('Enable Biometric Lock?'),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton.icon(onPressed: completeSetup, icon: const
              Icon(Icons.navigate_next), label: const Text('Complete Setup')),
            )
          ],
        ),
      ),
    );
  }
}