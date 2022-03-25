import 'package:flutter/material.dart';
import 'package:fun_ideas/utilities/constants.dart';
import 'package:fun_ideas/utilities/utils.dart';
import 'package:provider/provider.dart';
import '../widgets/get_name_widget.dart';
import '../widgets/get_bio_lock_widget.dart';
import '../models/app_state.dart';
import '../models/user.dart';
import '../utilities/auth_ops.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final _pageController = PageController();

  void nextPage() async {
    if(Provider.of<AppState>(context, listen: false).setUpStage == setupStages.nameStage){
      if (Provider.of<AppState>(context, listen: false).name.isEmpty) {
        showSnackBar(
            context: context, message: 'Name field is empty!', error: true);
        return;
      }
      _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      Provider.of<AppState>(context, listen: false)
          .setSetupStage(setupStages.bioLockStage);
    } else {
      final newUser = User(firstName: Provider.of<AppState>(context, listen: false).name, hasBiometricLock: Provider.of<AppState>(context, listen: false)
          .bioLockEnabled);
      final authOps = AuthOps();
      await authOps.open();
      if(await authOps.setUser(newUser)){
        Navigator.pushNamedAndRemoveUntil(context, '/homePage', (route) => false);
      } else {
        showSnackBar(context: context, message: 'Failed setting up new user.',error: true);
      }
    }
  }

  void previousPage() async {
    Provider.of<AppState>(context, listen: false)
        .setSetupStage(setupStages.nameStage);
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void completeSetUp () {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.chevron_left),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      'Fun Ideas',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Spacer(
                      flex: 3,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 16.0, right: 16),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quick Setup',
                      style: Theme.of(context).textTheme.headline6,
                    )),
              ),
              Expanded(
                  child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  GetNameWidget(pageController: _pageController),
                  GetBioLockWidget(
                    pageController: _pageController,
                  )
                ],
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                        visible: Provider.of<AppState>(context).setUpStage ==
                            setupStages.bioLockStage,
                        child: TextButton.icon(
                          onPressed: previousPage,
                          icon: const Icon(Icons.chevron_left),
                          label: const Text('Previous'),
                        )),
                    TextButton.icon(
                      onPressed: nextPage,
                      icon: Icon(Provider.of<AppState>(context).setUpStage ==
                              setupStages.nameStage
                          ? Icons.chevron_right
                          : Icons.done),
                      label: Text(Provider.of<AppState>(context).setUpStage ==
                              setupStages.nameStage
                          ? 'Next'
                          : 'Complete Setup'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
