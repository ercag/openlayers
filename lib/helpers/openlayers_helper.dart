// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:js' as js;

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

  void runJs([dynamic args]) {
    html.Element frame = html.querySelector("#openlayersiframe")!;
    var jsFrame = js.JsObject.fromBrowserObject(frame);
    js.JsObject jsDocument = jsFrame['contentWindow']["window"];
    jsDocument.callMethod("executeFunction", [js.JsObject.jsify(args)]);
  }
}
