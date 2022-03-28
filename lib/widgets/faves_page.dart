import 'package:flutter/material.dart';
import '../utilities/db_ops.dart';
import '../models/activity.dart';
import '../widgets/idea_tile.dart';
import '../utilities/utils.dart';

class FavesPage extends StatefulWidget {
  const FavesPage({Key? key}) : super(key: key);

  @override
  State<FavesPage> createState() => _FavesPageState();
}

class _FavesPageState extends State<FavesPage> {
  DBOps dbOps = DBOps();
  final allUncompletedActivities = <Activity>[];
  final allCompletedActivities = <Activity>[];


  completeActivity(int index) async {

    final res = await dbOps.updateActivityStatus(allUncompletedActivities[index].id, allUncompletedActivities[index].completed == 1 ? 0 : 1);
    if(res == 1){
      var changedActivity = Activity(id: allUncompletedActivities[index].id,activity: allUncompletedActivities[index].activity,completed: allUncompletedActivities[index].completed == 1 ? 0 : 1);
      setState(() {
        allUncompletedActivities.removeAt(index);
        allCompletedActivities.add(changedActivity);
      });
    } else {
      showSnackBar(context: context, message: 'Failed to change status');
    }
  }

  unCompleteActivity(int index) async {
    final res = await dbOps.updateActivityStatus(allCompletedActivities[index].id, allCompletedActivities[index].completed == 1 ? 0 : 1);
    if(res == 1){
      var changedActivity = Activity(id: allCompletedActivities[index].id,activity: allCompletedActivities[index].activity,completed: allCompletedActivities[index].completed == 1 ? 0 : 1);
      setState(() {
        allCompletedActivities.removeAt(index);
        allUncompletedActivities.add(changedActivity);
      });
    } else {
      showSnackBar(context: context, message: 'Failed to change status');
    }
  }

  init() async {
    await dbOps.openDB();
    final storedActivities = await dbOps.getActivities();
    setState(() {
      allUncompletedActivities.addAll(storedActivities.where((activity) => activity.completed == 0).toList());
      allCompletedActivities.addAll(storedActivities.where((activity) => activity.completed == 1).toList());
    });
  }

  deleteUncompleted(int index) async {
    if(await dbOps.deleteActivityById(allUncompletedActivities[index].id) == 1){
      allUncompletedActivities.removeAt(index);
    }
  }

  deleteCompleted(int index) async {
    if(await dbOps.deleteActivityById(allCompletedActivities[index].id) == 1){
      allCompletedActivities.removeAt(index);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text('Uncompleted',style: Theme.of(context).textTheme.headline6,),),
          allUncompletedActivities.isEmpty ? const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text('No data'),
          )) : SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index){
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.delete_forever), label: const Text('Delete'),style: TextButton.styleFrom(primary: Colors.white)),
                          )),
                    ),
                    onDismissed: (_) => deleteUncompleted(index),
                    direction: DismissDirection.endToStart,
                    key: Key(allUncompletedActivities[index].id),
                    child: IdeaTile(activity: allUncompletedActivities[index],changeCompletionStatus: () => completeActivity(index)),
                  );
          },childCount: allUncompletedActivities.length)),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Completed',style: Theme.of(context).textTheme.headline6,),
          ),),
          allCompletedActivities.isEmpty ? const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text('No data'),
          )) : SliverList(delegate: SliverChildBuilderDelegate((_, index){
            return Dismissible(
              background: Container(
                color: Colors.red,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.delete_forever), label: const Text('Delete'),style: TextButton.styleFrom(primary: Colors.white)),
                    )),
              ),
              onDismissed: (_)=> deleteCompleted(index),
              direction: DismissDirection.endToStart,
              key: Key(allCompletedActivities[index].id),
              child: IdeaTile(activity: allCompletedActivities[index],changeCompletionStatus: () => unCompleteActivity(index)),
            );
          },childCount: allCompletedActivities.length))
        ],
      ),
    );
  }
}
