import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  BitmapDescriptor mapIcon = BitmapDescriptor.defaultMarker;

  Completer<GoogleMapController> mapControl = Completer();
  var firstLocation = const CameraPosition(target: LatLng(38, 26), zoom: 4);

  goLocation() async {
    GoogleMapController controller = await mapControl.future;
    var address = const CameraPosition(
      target: LatLng(37.876130764629025, 32.48967776954579),
      zoom: 8,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(address));
  }

  markersCreate() async {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    await BitmapDescriptor.fromAssetImage(configuration, "assets/mapIcon.png").then((value) {
      mapIcon = value;
    });

    var marker1 = const Marker(
        markerId: MarkerId("1"),
        position: LatLng(37.876130764629025, 32.48967776954579),
        infoWindow: InfoWindow(
          title: "Marker 1 Title",
          snippet: "Description",
        ));

    var marker2 = Marker(
        icon: mapIcon,
        markerId: const MarkerId("2"),
        position: const LatLng(37.576130764629025, 32.28967776954579),
        infoWindow: const InfoWindow(
          title: "Marker 2 Title",
          snippet: "Description",
        ));

    markers.add(marker1);
    markers.add(marker2);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    markersCreate();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        centerTitle: true,
        title: const Text(
          "Map Demo",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              child: GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers),
                  initialCameraPosition: firstLocation,
                  onMapCreated: (GoogleMapController controller) {
                    mapControl.complete(controller);
                  }),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton.icon(
              onPressed: () {
                goLocation();
              },
              icon: const Icon(Icons.location_searching),
              label: const Text("Go Address"),
            ),
          ],
        ),
      ),
    );
  }
}
