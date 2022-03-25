import 'package:flutter/material.dart';
import '../utilities/app_themes.dart';

class GetBioLockWidget extends StatefulWidget {
  const GetBioLockWidget({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  State<GetBioLockWidget> createState() => _GetBioLockWidgetState();
}

class _GetBioLockWidgetState extends State<GetBioLockWidget> {

  var isBioLockCapable = false;

  void previous() {
    widget.pageController.animateToPage(0, duration: const Duration
      (milliseconds: 500), curve: Curves.easeIn);
  }

  void init() async {

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
          padding: const EdgeInsets.only(left: 32,top: 32),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Biometric Lock',style: Theme.of
                (context).textTheme.labelLarge,)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0,left: 16,right: 16),
          child: ListTile(
            leading: Icon(Icons.clear,color: Colors.redAccent,),
            title: Text('Sorry, your phone does not support biometric '
                'lock/unlock'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:16,right: 16.0,top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: previous, icon: const Icon(Icons
                  .chevron_left_outlined,size: 32,color: Colors.purpleAccent,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons
                  .chevron_right_outlined,size: 32,color: spaceCadet,))
            ],
          ),
        )
      ],
    );
  }
}