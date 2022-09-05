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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(MediaQuery.of(context).size.width.toString()),
        OpenLayers(
            width: (MediaQuery.of(context).size.width / 2).toString(),
            height: "300"),
        TextButton(
            onPressed: () {
              double lon = 29.12349029753785;
              double lat = 40.95089078729886;
              List<double> convertedCoordinate =
                  OpenLayers.helper.convertCoordinate(lon, lat);
              int zoom = 15;
              double duration = 2000;
              OpenLayers.helper.runJs([
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
