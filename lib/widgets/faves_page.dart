import 'package:flutter/material.dart';
import '../utilities/db_ops.dart';
import '../models/activity.dart';

class FavesPage extends StatefulWidget {
  const FavesPage({Key? key}) : super(key: key);

  @override
  State<FavesPage> createState() => _FavesPageState();
}

class _FavesPageState extends State<FavesPage> {
  DBOps dbOps = DBOps();
  final allUncompletedActivities = <Activity>[];
  final allCompletedActivities = <Activity>[];

  init() async {
    await dbOps.openDB();
    final storedActivities = await dbOps.getActivities();
    setState(() {
      allUncompletedActivities.addAll(storedActivities.where((activity) => activity.completed == 0).toList());
      allCompletedActivities.addAll(storedActivities.where((activity) => activity.completed == 1).toList());
    });
  }

  deleteUncompleted(index) async {
    if(await dbOps.deleteActivityById(allUncompletedActivities[index].id) == 1){

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
                            child: TextButton.icon(onPressed: (){}, icon: const Icon(Icons.delete_forever), label: Text('Delete'),style: TextButton.styleFrom(primary: Colors.white)),
                          )),
                    ),
                    onDismissed: (dismissDirection){

                    },
                    direction: DismissDirection.endToStart,
                    key: Key(allUncompletedActivities[index].id),
                    child: ListTile(
                      title: Text(allUncompletedActivities[index].activity),
                      trailing: OutlinedButton(child: Text('Complete'),onPressed: (){}),
                    ),
                  );
          },childCount: allUncompletedActivities.length)),
          SliverToBoxAdapter(child: Text('Completed',style: Theme.of(context).textTheme.headline6,),),
          allCompletedActivities.isEmpty ? const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text('No data'),
          )) : SliverList(delegate: SliverChildBuilderDelegate((_, index){
            return Dismissible(
              key: Key(allCompletedActivities[index].id),
              child: ListTile(
                title: Text(allCompletedActivities[index].activity),
              ),
            );
          },childCount: allCompletedActivities.length))
        ],
      ),
    );
  }
}
