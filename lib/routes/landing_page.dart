import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../utilities/auth_ops.dart';
import '../utilities/utils.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  void start(BuildContext context) async {
    final authOps = AuthOps();
    await authOps.open();
    final user = authOps.getUser();
    if (user.firstName.isEmpty) {
      Navigator.pushNamed(context, '/setUpPage');
    } else {
      if (user.hasBiometricLock) {
        var localAuth = LocalAuthentication();
        try {
          bool didAuthenticate = await localAuth.authenticate(
              localizedReason: 'Please authenticate to get in the app',
              biometricOnly: true);
          if(didAuthenticate){
            Navigator.pushNamedAndRemoveUntil(
                context, '/homePage', (route) => false);
          } else {
            showSnackBar(context: context, message: 'Authentication Failed!',error: true);
          }
        } catch (e) {
          print(e.toString());
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/homePage', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/idea.png',
                    height: 128,
                    width: 128,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Fun Ideas',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () => start(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Check Ideas',
                      style: TextStyle(fontSize: 18),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
