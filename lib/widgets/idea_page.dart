import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../utilities/constants.dart';
import '../utilities/app_themes.dart';
import '../utilities/db_ops.dart';
import '../models/activity.dart';
import '../utilities/utils.dart';

class IdeaPage extends StatefulWidget {
  const IdeaPage({Key? key}) : super(key: key);

  @override
  State<IdeaPage> createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  var stage = httpRequestStages.fetching;
  var isFavourited = false;
  String nextActivity = '';
  DBOps dbOps = DBOps();
  var nextText = 'Not fun. Another';

   getNextActivity() async {
    setState(() {
      stage = httpRequestStages.fetching;
      isFavourited = false;
    });
    final response = await http.get(Uri.parse(activityApi));
    try {
      if (response.statusCode == 200) {
        setState(() {
          nextActivity = jsonDecode(response.body)['activity'];
          stage = httpRequestStages.fetched;
          nextText = 'Not fun. Another';
        });
      } else {
        setState(() {
          nextActivity = 'An error occurred!';
          stage = httpRequestStages.error;
        });
      }
    } catch (e) {
      setState(() {
        nextActivity = 'An error occurred!';
        stage = httpRequestStages.error;
      });
    }
  }

  handleIsFavourited() async {
    final res = await dbOps.activityExists(nextActivity);
    setState(() {
      isFavourited = res;
    });
  }

  void addToFaves() async {
     if(await dbOps.activityExists(nextActivity)){
       final res = await dbOps.deleteActivity(nextActivity);
       if(res == 1){
         setState(() {
           isFavourited = !isFavourited;
           nextText = 'Not fun. Another';
         });
       } else {
         showSnackBar(context: context,message: 'Failed removing from favourites',error: true);
       }
     } else {
       final res = await dbOps.addToDB(Activity(
           id: const Uuid().v4().toString(),
           activity: nextActivity,
           completed: 0));
       if (res > 0) {
         setState(() {
           isFavourited = !isFavourited;
           nextText = 'Another';
         });
       } else {
         showSnackBar(context: context,message: 'Failed adding to favourites',error: true);
       }
     }

  }

  void init() async  {
    dbOps.openDB();
    await getNextActivity();
    handleIsFavourited();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    dbOps.closeDB();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: isFavourited ? Colors.red[100] : Colors.transparent,
                  size: 128,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: stage == httpRequestStages.fetched ? 1.0 : 0.0,
                  child: GestureDetector(
                    onDoubleTap: addToFaves,
                    child: Text(
                      '"'
                      '$nextActivity'
                      '"',
                      style: const TextStyle(color: spaceCadet, fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                    visible: stage == httpRequestStages.fetching,
                    child: const CircularProgressIndicator.adaptive()),
              ],
            ),
          ),
          Visibility(
              visible: stage == httpRequestStages.fetched,
              child: const Text(
                'Double tap to add to favourites',
              )),
          Visibility(
            visible: stage == httpRequestStages.fetched,
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: TextButton.icon(
                  onPressed: getNextActivity,
                  icon: const Icon(Icons.autorenew),
                  label: Text(nextText)),
            ),
          )
        ],
      ),
    );
  }
}
