import 'package:flutter/material.dart';

class GoogleMapWidget extends StatelessWidget {
  final double lat;
  final double lng;

  GoogleMapWidget({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    // Create a unique key for the HTML view to identify the element
    final String mapId = 'google-map-${lat}-${lng}';

    // Embed the HTML element using HtmlElementView
    return HtmlElementView(
      viewType: mapId,
    );
  }
}
