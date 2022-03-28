import 'package:flutter/material.dart';
import '../models/activity.dart';

class IdeaTile extends StatefulWidget {
  const IdeaTile({Key? key, required this.activity, required this.changeCompletionStatus}) : super(key: key);

  final Activity activity;
  final VoidCallback changeCompletionStatus;

  @override
  State<IdeaTile> createState() => _IdeaTileState();
}

class _IdeaTileState extends State<IdeaTile> {

  bool checked = false;

  @override
  void initState() {
    super.initState();
    checked = widget.activity.completed == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0,left: 16.0),
            child: Text(widget.activity.activity,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
          ),
          ListTile(
            leading: Checkbox(value: checked,onChanged: (value){
              setState(() {
                checked = value!;
              });
              widget.changeCompletionStatus();
            }),
            title: Text(checked ? 'Mark Uncompleted' : 'Mark Completed'),
          )
        ],
      ),
    );
  }
}
