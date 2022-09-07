// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'package:webview_flutter/webview_flutter.dart';

class OpenLayersHelper {
  List<double> convertCoordinate(double lon, double lat) {
    List<double> retval = [];
    var x = (lon * 20037508.34) / 180;
    var y = math.log(math.tan(((90 + lat) * math.pi) / 360)) / (math.pi / 180);
    y = (y * 20037508.34) / 180;
    retval.add(x);
    retval.add(y);
    return retval;
  }

  void runJs(WebViewController? controller, [dynamic args]) {
    if (kIsWeb) {
      html.Element frame = html.querySelector("#openlayersiframe")!;
      var jsFrame = js.JsObject.fromBrowserObject(frame) as Map;
      js.JsObject jsDocument = jsFrame['contentWindow']["window"];
      jsDocument.callMethod("executeFunction", [js.JsObject.jsify(args)]);
    }

    if (Platform.isAndroid || Platform.isIOS) {
      if (controller != null) {
        String funcName = args[0];
        String jsToCall = "$funcName(${args[1]})";
        controller.runJavascript(jsToCall);
      }
    }
  }
}
