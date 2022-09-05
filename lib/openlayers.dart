// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:openlayers/helpers/openlayers_helper.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class OpenLayers extends StatefulWidget {
  const OpenLayers({Key? key, required this.width, required this.height})
      : super(key: key);
  final String width;
  final String height;
  static OpenLayersHelper helper = OpenLayersHelper();

  @override
  State<OpenLayers> createState() => _OpenLayersState();
}

class _OpenLayersState extends State<OpenLayers> {
  @override
  Widget build(BuildContext context) {
    Widget map = Container();
    if (kIsWeb) {
      map = webMap();
    }

    if (Platform.isAndroid || Platform.isIOS) {
      map = mobileMap();
    }

    return SizedBox(
        width: double.parse(widget.width.isEmpty ? "100" : widget.width),
        height: double.parse(widget.height.isEmpty ? "100" : widget.height),
        child: map);
  }

  Widget mobileMap() {
    return WebViewPlus(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        controller.loadUrl('./assets/packages/openlayers/assets/index.html');
      },
    );
  }

  Widget webMap() {
    final html.IFrameElement iframeElement = html.IFrameElement();
    iframeElement.width = "100%";
    iframeElement.height = "100%";
    iframeElement.src = './assets/packages/openlayers/assets/index.html';
    iframeElement.style.border = 'none';
    iframeElement.id = 'openlayersiframe';
    iframeElement.setAttribute("scrolling", "no");

    final wrapper = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%';
    wrapper.append(iframeElement);

    String viewID = "map-id";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewID,
      (int viewId) => wrapper,
    );

    return HtmlElementView(
      viewType: viewID,
    );
  }
}
