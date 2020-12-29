import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMapView extends StatefulWidget {


  @override
  _FullScreenMapViewState createState() => _FullScreenMapViewState();
}

class _FullScreenMapViewState extends State<FullScreenMapView> {

  static const String ACCESS_TOKEN = 'pk.eyJ1IjoiYW5kcmVzc2FsZ2Fkb2MxIiwiYSI6ImNrajlmZ3p4bjFvcHcycW55cHQ3NXQ0a3cifQ.GFutpgV9U3PEkyV13khu1w';
  // final center = LatLng(37.810575, -122.477174); 
  final center = LatLng(0.3508976590449501, -78.13236181534079); 
  final oscuroStyle = 'mapbox://styles/andressalgadoc1/ckj9gjy3l6uzc19ldqx8x7xim';
  final streetsStyle = 'mapbox://styles/andressalgadoc1/ckj9gmuk36t8l19qmjg1nu2ve';

  String selectedStyle = 'mapbox://styles/andressalgadoc1/ckj9gmuk36t8l19qmjg1nu2ve';

  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://lh3.googleusercontent.com/proxy/6dfjNPXpltPkSHRNJqxbEm7dvH_sxmpuBY7wsI1r46XgYP5lLJvQtLJQrE5Tk6N86OTre-FRuw9cmxXLAl9QaHGPcan-sePVmQ");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes() ,
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Símbolos
        FloatingActionButton(
          child: Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            
            mapController.addSymbol( SymbolOptions(

              geometry: center,
              iconSize: 1,
              iconImage: 'networkImage',
              textField: 'Atracción',
              textOffset: Offset(0, 2)

            ));

          },
        ),

        SizedBox(height: 5,),

        // ZoomIn
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
        ),

        SizedBox(height: 5,),

        // ZoomOut
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),

        SizedBox(height: 5,),
        
        // Cambiar estilo
        FloatingActionButton(
          child: Icon(Icons.brightness_4),
          onPressed: () {
            if(selectedStyle == oscuroStyle) {
              selectedStyle = streetsStyle;
            } else {
              selectedStyle = oscuroStyle;
            }

            setState(() {
              _onStyleLoaded();
            });
          },
        )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      accessToken: ACCESS_TOKEN,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 16
      ),
    );
  }
}