import 'package:sqflite/sqflite.dart';

class LocalDB {
  Database? db;
  String dbPath = "flutter_test.db";

  String employeeTableScript = "CREATE TABLE Employee (id, name, mobile, email, address, role, userId, latitude, longitude)";

  Future<void> initDB() async {
    db = await openDatabase(dbPath, version: 1, onCreate: (Database db, int version) async {
      await db.execute(employeeTableScript);
    });
  }

  void closeDB() async {
    await db?.close();
  }

  void deleteDB() async {
    await deleteDatabase(dbPath);
  }

  Future<void> insertEmployeeData(Map<String, dynamic> data) async {
    try {
      if (db == null) await initDB();

      String script = ''
          'INSERT INTO Employee(id, name, mobile, email, address, role, userId, latitude, longitude)'
          'VALUES("${data['id']}", "${data['name']}", "${data['mobile']}", "${data['email']}", "${data['address']}", "${data['role']}", "${data['userId']}", "${data['latitude']}", "${data['longitude']}")'
          '';

      await db!.transaction((txn) async {
        int id1 = await txn.rawInsert(script);
        print('insertData => inserted1: $id1');
      });
    } catch (e) {
      print('insertData => error: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeeData() async {
    try {
      if (db == null) await initDB();

      String script = 'SELECT * FROM Employee';
      return await db!.rawQuery(script);
    } catch (e) {
      print('insertData => error: ${e.toString()}');
      return [];
    }
  }
}
