import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/utils.dart';
import '../utilities/app_themes.dart';
import '../models/app_state.dart';

class GetNameWidget extends StatefulWidget {
  const GetNameWidget({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  State<GetNameWidget> createState() => _GetNameWidgetState();
}

class _GetNameWidgetState extends State<GetNameWidget> {
  final firstNameTEC = TextEditingController();
  String? firstNameError;

  void next() async {
    if(firstNameTEC.text.isEmpty){
      setState(() {
        firstNameError = 'Please enter your first name';
      });
      return;
    }
    Provider.of<AppState>(context,listen: false).setName(firstNameTEC.text);
    widget.pageController.animateToPage(1, duration: const Duration
      (milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32,top: 32),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Tell us your first name',style: Theme.of
                (context).textTheme.labelLarge,)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0,left: 32,right: 32),
          child: TextField(
            controller: firstNameTEC,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0,top: 8),
          child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(onPressed: next, icon: const Icon(Icons
                  .chevron_right_outlined,size: 32,color: spaceCadet,))),
        )
      ],
    );
  }
}