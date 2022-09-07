// ignore_for_file: avoid_web_libraries_in_flutter, import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_ui/universal_ui.dart';
import 'package:universal_html/html.dart' as html;

import 'package:openlayers/helpers/openlayers_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenLayers extends StatefulWidget {
  const OpenLayers(
      {Key? key,
      required this.width,
      required this.height,
      this.onWebViewCreated})
      : super(key: key);
  final String width;
  final String height;
  final WebViewCreatedCallback? onWebViewCreated;
  static OpenLayersHelper helper = OpenLayersHelper();

  @override
  State<OpenLayers> createState() => _OpenLayersState();
}

class _OpenLayersState extends State<OpenLayers> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Widget map = Container();
    if (kIsWeb) {
      map = webMap();
    }

    if (Platform.isAndroid || Platform.isIOS) {
      map = mobileMap();
    }

    return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight:
                double.parse(widget.height.isEmpty ? "100" : widget.height),
            maxWidth:
                double.parse(widget.width.isEmpty ? "100" : widget.width)),
        child: map);
  }

  WebView mobileMap() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      backgroundColor: Colors.transparent,
      userAgent:
          "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0",
      zoomEnabled: true,
      onWebViewCreated: (controller) {
        widget.onWebViewCreated!(controller);
        controller.loadUrl(
            "file:///android_asset/flutter_assets/packages/openlayers/assets/index.html");
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
    ui.platformViewRegistry.registerViewFactory(
      viewID,
      (int viewId) => wrapper,
    );

    return HtmlElementView(
      viewType: viewID,
    );
  }
}
