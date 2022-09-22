import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController? mapController;
  final center = LatLng(7.098452, -73.114805);
  String selectedStyle =
      'mapbox://styles/andresbadillo/cl8c22ya0000r14s9pr8b9dy8';

  final styleDark = 'mapbox://styles/andresbadillo/cl8c1yi2n000o14oa2kazw8xt';
  final styleStreet = 'mapbox://styles/andresbadillo/cl8c22ya0000r14s9pr8b9dy8';

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/symbols/custom-icon.png");
    addImageFromUrl(
        "networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController!.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController!.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Simbolos
        FloatingActionButton.small(
          child: const Icon(Icons.eco),
          onPressed: () {
            mapController?.addSymbol(SymbolOptions(
                geometry: center,
                iconImage: 'assetImage',
                iconSize: 2,
                textField: 'Montaña creada',
                textOffset: Offset(0, 1.5)));
          },
        ),
        // Zoom in
        FloatingActionButton.small(
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            mapController?.animateCamera(CameraUpdate.zoomIn());
          },
        ),
        // Zoom out
        FloatingActionButton.small(
          child: const Icon(Icons.zoom_out),
          onPressed: () {
            mapController?.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        const SizedBox(height: 10),
        // Cambiar estilo
        FloatingActionButton(
          elevation: 2,
          child: const Icon(Icons.streetview),
          onPressed: () {
            if (selectedStyle == styleDark) {
              selectedStyle = styleStreet;
            } else {
              selectedStyle = styleDark;
            }
            _onStyleLoaded();
            setState(() {});
          },
        )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      onMapCreated: _onMapCreated,
      styleString: selectedStyle,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 16.0,
      ),
    );
  }
}
