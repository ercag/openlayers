var map;
const istanbul = ol.proj.fromLonLat([28.9744, 41.0128]);
const london = ol.proj.fromLonLat([-0.12755, 51.507222]);

const layers = [
    new ol.layer.Tile({
        source: new ol.source.OSM()
    }),
];

const view = new ol.View({
    center: london,
    zoom: 6,
});

function createMap(targetDiv) {
    var target = document.getElementById("map");
    if (target == null) {
        console.log("map div didn't find.");
        return;
    }

    map = new ol.Map({
        layers: layers,
        target: targetDiv,
        view: view
    });

    zoomslider = new ol.control.ZoomSlider();
    map.addControl(zoomslider);
}

//function to execute some other function by it's string name 
function executeFunction(args) {
    var functionName = arguments[0][0];
    var args = arguments[0][1];

    if (functionName.includes(".")) {
        let contextFromArg = functionName.split(".")[0];
        switch (contextFromArg) {
            case "view":
                context = view;
                break;
            case "map":
                context = map;
                break;
            case "ol":
                context = ol;
                break;
            case "layers":
                context = layers;
                break;
            default:
                break;
        }

        functionName = functionName.split(".")[1];
    }
    return context[functionName].apply(context, [args]);
}