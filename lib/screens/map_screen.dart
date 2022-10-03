import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place_location.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation? selectedLocation;
  final LatLng initialPosition;
  final bool isReadOnly;

  const MapScreen({
    Key? key,
    this.selectedLocation,
    this.initialPosition = const LatLng(
      37.419857,
      -122.078827,
    ),
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.selectedLocation != null
        ? LatLng(
            widget.selectedLocation!.latitude,
            widget.selectedLocation!.longitude,
          )
        : null;
  }

  void _selectPosition(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select...'),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
                onPressed: _selectedPosition != null
                    ? () => Navigator.of(context).pop(_selectedPosition)
                    : null,
                icon: const Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: _selectedPosition == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('l1'),
                  position: _selectedPosition!,
                ),
              },
      ),
    );
  }
}
