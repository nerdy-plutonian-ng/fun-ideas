import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fun_ideas/models/user.dart';

import '../utilities/auth_ops.dart';
import '../widgets/authenticate_widget.dart';
import '../widgets/setup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  User? _user;

  init() async {
    final authOps = AuthOps();
    await authOps.open();
    if (kDebugMode) {
      print(authOps.getUser().toMap());
    }
    setState(() {
      _user = authOps.getUser();
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user == null ? const Center(child: CircularProgressIndicator.adaptive()) :
      _user!.firstName.isEmpty ? const SetupWidget() :
      AuthenticateWidget(user: _user!),
    );
  }
}