import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';

class DBOps {

  late Database db;

  openDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'funIdeas.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE FunIdeas (id TEXT PRIMARY KEY, activity TEXT, completed INTEGER)');
        });
  }

  closeDB() async {
    await db.close();
  }

  Future<int> addToDB(Activity activity) async {
    return await db.insert('FunIdeas', activity.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Activity>> getActivities() async {
    final storedActivities = await db.query('FunIdeas');
    return storedActivities.map((activityMap) => Activity.fromJson(activityMap)).toList();
  }

  Future<int> deleteActivity(String activity) async {
    return await db.delete('FunIdeas',where: 'activity = ?',whereArgs: [activity]);
  }

  Future<int> deleteActivityById(String id) async {
    return await db.delete('FunIdeas',where: 'id = ?',whereArgs: [id]);
  }

  Future<bool> activityExists(String activity) async {
    return (await db.query('FunIdeas',where: 'activity = ?',whereArgs: [activity])).isNotEmpty;
  }


}