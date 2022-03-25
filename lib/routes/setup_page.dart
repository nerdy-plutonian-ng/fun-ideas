import 'package:flutter/material.dart';
import '../widgets/get_name_widget.dart';
import '../widgets/get_bio_lock_widget.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  final pageController = PageController();

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
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon
                      (Icons
                        .chevron_left),),
                    const Spacer(flex: 2),
                    Text('Fun Ideas',style: Theme.of(context).textTheme.headline5,),
                    const Spacer(flex: 3,)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32,left: 16.0,right: 16),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Quick Setup',style: Theme.of
                      (context).textTheme.headline6,)),
              ),
              Expanded(child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [GetNameWidget
                (pageController: pageController), GetBioLockWidget
                  (pageController: pageController,)],))
            ],
          ),
        ),
      ),
    );
  }
}