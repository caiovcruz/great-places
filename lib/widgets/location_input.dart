import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

import '../models/place_location.dart';
import '../utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final void Function(LatLng) onSelectPosition;

  const LocationInput({
    Key? key,
    required this.onSelectPosition,
  }) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _placeLocation;
  String? _previewImageUrl;
  bool _isLoading = false;

  Future<void> _setPlaceLocation(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: latitude,
        longitude: longitude,
      );

      setState(() {
        _previewImageUrl = staticMapImageUrl;
        _placeLocation = PlaceLocation(
          latitude: latitude,
          longitude: longitude,
        );
      });

      widget.onSelectPosition(LatLng(latitude, longitude));
    }
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      setState(() => _isLoading = true);

      final locData = await Location().getLocation();

      _setPlaceLocation(locData.latitude, locData.longitude);

      setState(() => _isLoading = false);
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    try {
      final LatLng? selectedLocation =
          await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(selectedLocation: _placeLocation),
      ));

      _setPlaceLocation(
          selectedLocation?.latitude, selectedLocation?.longitude);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _previewImageUrl == null
                  ? const Text('No location informed')
                  : GestureDetector(
                      onTap: _selectOnMap,
                      child: Image.network(
                        _previewImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on_rounded),
              label: const Text('Currently Location'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
