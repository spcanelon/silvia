LeafletWidget.methods.addMapboxGL = function(setView, layerId, group, options) {
  if (options.accessToken === null) {
    options.accessToken = "na";
  }
  var layer = L.mapboxGL(options);
  this.layerManager.addLayer(layer, "mapbox-gl-js", layerId, group);

  var leafletMap = this;

  layer._glMap.on("load", function() {
    if (setView) {
      if (layer._glMap.style && layer._glMap.style.stylesheet) {
        var ss = layer._glMap.style.stylesheet;
        if (ss.center && typeof(ss.zoom) !== "undefined") {
          leafletMap.setView([ss.center[1], ss.center[0]], ss.zoom + 1);
        }
      }
    }

    // Fixes https://github.com/rstudio/leaflet.mapboxgl/issues/1
    layer._update();
  });
};
