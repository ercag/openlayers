import 'package:flutter/material.dart';
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
            onPressed: () {
              double lon = 29.12349029753785;
              double lat = 40.95089078729886;
              List<double> convertedCoordinate =
                  OpenLayers.helper.convertCoordinate(lon, lat);
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
            child: const Text("test"))
      ],
    );
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
