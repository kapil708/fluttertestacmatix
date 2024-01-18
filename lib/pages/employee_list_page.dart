import 'package:flutter/material.dart';

import '../injection.dart';
import '../services/local_db_service.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Map<String, dynamic>> employeeList = [];

  @override
  void initState() {
    getEmployeeData();
    super.initState();
  }

  void getEmployeeData() async {
    employeeList = await getIt.get<LocalDB>().getEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee list")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getIt.get<LocalDB>().getEmployeeData(), // a previously-obtained Future<String> or null
        builder: (ctx, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> employee = snapshot.data?[index] ?? {};
                    return ListTile(
                      title: Text(
                        employee['name'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        "${employee['mobile']}, ${employee['role']} "
                        "\n${employee['email']}, ${employee['address']}",
                      ),
                    );
                  },
                )
              : snapshot.hasError
                  ? Text(snapshot.error.toString())
                  : const CircularProgressIndicator();
        },
      ),
    );
  }
}
