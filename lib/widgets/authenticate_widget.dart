import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../routes/home_page.dart';
import '../models/user.dart';

class AuthenticateWidget extends StatefulWidget {
  const AuthenticateWidget({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AuthenticateWidget> createState() => _AuthenticateWidgetState();
}

class _AuthenticateWidgetState extends State<AuthenticateWidget> {

  init() async {
    try {
      if (widget.user.hasBiometricLock) {
        var localAuth = LocalAuthentication();
        if(await localAuth.canCheckBiometrics){
          bool didAuthenticate =
          await localAuth.authenticate(
              localizedReason: 'Please authenticate yourself',
              biometricOnly: true);
          if(didAuthenticate){
            Navigator.pushNamed(context, HomePage.routeName);
          }
        }
      }
    } on PlatformException catch (e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/idea.png',width: 128,height: 128,),
          Visibility(
            visible: !widget.user.hasBiometricLock,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, HomePage
                    .routeName, (route) => false);
              }, child: const Text('GO')),
            ),
          ),
        ],
      ),
    );
  }
}