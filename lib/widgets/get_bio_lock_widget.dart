import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart';
import '../models/app_state.dart';

class GetBioLockWidget extends StatefulWidget {
  const GetBioLockWidget({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<GetBioLockWidget> createState() => _GetBioLockWidgetState();
}

class _GetBioLockWidgetState extends State<GetBioLockWidget> {
  bioLockOptions _lockOptions = bioLockOptions.noHardware;
  var hasBioLockAdded = false;

  void previous() {
    widget.pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void init() async {
    var localAuth = LocalAuthentication();
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    if(canCheckBiometrics){
      setState(() {
        _lockOptions = bioLockOptions.hasHardware;
      });
    } else {
      setState(() {
        _lockOptions = bioLockOptions.noHardware;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32, top: 32),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Biometric Lock',
                style: Theme.of(context).textTheme.labelLarge,
              )),
        ),
        _lockOptions == bioLockOptions.noHardware
            ? const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: ListTile(
                  leading: Icon(
                    Icons.clear,
                    color: Colors.redAccent,
                  ),
                  title: Text('Sorry, your phone does not support biometric '
                      'lock/unlock or have registered none.'),
                ),
              )
            : Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
          child: Consumer<AppState>(
            builder: (_,appState,__){
              return ListTile(
                leading: Checkbox(value: appState.bioLockEnabled, onChanged: (value){
                  appState.setBioLock(value!);
                }),
                title: Text('Ask for biometric unlock every time you start the app'),
              );
            },

          ),
        ),
      ],
    );
  }
}
