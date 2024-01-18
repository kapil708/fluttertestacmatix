import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../injection.dart';
import '../services/local_db_service.dart';
import '../services/session_service.dart';
import 'add_employee_page.dart';
import 'employee_list_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String username = "";

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.1702, 72.8311),
    zoom: 14.4746,
  );

  @override
  void initState() {
    getUserData();
    getEmployeeData();
    super.initState();
  }

  void getUserData() async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic>? userData = await SessionService().getUserData();
    if (userData != null) {
      setState(() {
        username = userData['name'];
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void getEmployeeData() async {
    List<Map<String, dynamic>> list = await getIt.get<LocalDB>().getEmployeeData();
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        createMarket(list[i]);
      }
    }
  }

  void createMarket(Map<String, dynamic> employee) {
    final String markerIdVal = DateTime.now().microsecondsSinceEpoch.toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(employee['latitude'].toString()),
        double.parse(employee['longitude'].toString()),
      ),
      infoWindow: InfoWindow(
        title: employee['name'],
        snippet: '${employee['address']}',
      ),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username ?? "Home"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EmployeeListPage()),
              );
            },
            child: const Text("Employee list"),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (LatLng latLng) {
          showAddOptions(context, latLng);
        },
      ),
    );
  }

  showAddOptions(BuildContext context, LatLng latLng) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current location \n${latLng.latitude}, ${latLng.longitude}",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddEmployeePage(latLng: latLng)),
                  ).then((value) {
                    if (value != null && value == 1) {
                      getEmployeeData();
                    }
                  });
                },
                child: const Text("Add Employee"),
              ),
            ],
          ),
        );
      },
    );
  }
}
