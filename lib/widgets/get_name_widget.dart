import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/utils.dart';
import '../utilities/app_themes.dart';
import '../models/app_state.dart';

class GetNameWidget extends StatefulWidget {
  const GetNameWidget({Key? key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  State<GetNameWidget> createState() => _GetNameWidgetState();
}

class _GetNameWidgetState extends State<GetNameWidget> {
  String? firstNameError;
  final firstNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = Provider.of<AppState>(context,listen: false).name;
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
                'Tell us your first name',
                style: Theme.of(context).textTheme.labelLarge,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 32, right: 32),
          child: Consumer<AppState>(
            builder: (_, appState, __) {
              return TextField(
                controller: firstNameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                onSubmitted: (text){
                  if (text.contains(' ')) {
                    firstNameController.text = text.split(' ').first;
                    appState.setName(text.split(' ').first);
                    showSnackBar(
                        context: context,
                        message: 'Just your first name',
                        error: true);
                  }
                  appState.setName(text);
                },
                onChanged: (text) {
                  setState(() {
                    firstNameError = null;
                  });
                },
                decoration: InputDecoration(
                    label: const Text('First Name'), errorText: firstNameError),
              );
            },
          ),
        ),
      ],
    );
  }
}
