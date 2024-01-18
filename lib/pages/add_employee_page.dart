import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../injection.dart';
import '../services/local_db_service.dart';

// ignore: must_be_immutable
class AddEmployeePage extends StatelessWidget {
  final LatLng latLng;
  AddEmployeePage({super.key, required this.latLng});

  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtRole = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addEmployee(BuildContext context) async {
    Map<String, dynamic> employeeData = {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'name': txtName.text.trim(),
      'mobile': txtMobile.text.trim(),
      'email': txtEmail.text.trim(),
      'address': txtAddress.text.trim(),
      'role': txtRole.text.trim(),
      'userId': "10001",
      'latitude': latLng.latitude.toString(),
      'longitude': latLng.longitude.toString(),
    };

    await getIt.get<LocalDB>().insertEmployeeData(employeeData);

    // ignore: use_build_context_synchronously
    Navigator.pop(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add employee")),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: txtName,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: "Name", label: Text("Name")),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required field';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: txtMobile,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(hintText: "Mobile", label: Text("Mobile")),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required field';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: "Email address", label: Text("Email address")),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required field';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: txtRole,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: "Role", label: Text("Role")),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required field';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: txtAddress,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: "Address", label: Text("Address")),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required field';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addEmployee(context);
                    }
                  },
                  child: Text("Save details"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
