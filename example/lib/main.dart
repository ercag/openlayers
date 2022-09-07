import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:openlayers/openlayers.dart';

void main() {
  runApp(const MyApp());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_typing_uninitialized_variables
  var _webViewController;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OpenLayers(
            width: (MediaQuery.of(context).size.width).toString(),
            height: (MediaQuery.of(context).size.height / 2).toString(),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            }),
        TextButton(
            onPressed: () async {
              LocationData? loc = await getLocation();
              double? lon = loc?.longitude;
              double? lat = loc?.latitude;
              List<double> convertedCoordinate =
                  OpenLayers.helper.convertCoordinate(lon!, lat!);
              int zoom = 15;
              double duration = 2000;
              OpenLayers.helper.runJs(_webViewController, [
                "view.animate",
                {
                  "center": [
                    convertedCoordinate.first,
                    convertedCoordinate.last
                  ],
                  "zoom": zoom,
                  "duration": duration
                }
              ]);
            },
            child: const Text("Find Me"))
      ],
    );
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return locationData;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return locationData;
      }
    }

    locationData = await location.getLocation();

    return locationData;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Home(),
      ),
    );
  }
}
