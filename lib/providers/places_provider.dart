import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/models/place_location.dart';
import 'package:great_places/utils/db_util.dart';

import '../models/place.dart';
import '../utils/location_util.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.select('places');
    _items = dataList
        .map((data) => Place(
              id: data['id'],
              title: data['title'],
              location: PlaceLocation(
                latitude: data['latitude'],
                longitude: data['longitude'],
                address: data['address'],
              ),
              image: File(data['image']),
            ))
        .toList();
    notifyListeners();
  }

  List<Place> get items => [..._items];

  int get itemsCount => _items.length;

  Place itemByIndex(int index) => _items[index];

  Future<void> addPlace(
    String title,
    File image,
    LatLng position,
  ) async {
    String address = await LocationUtil.getAddressFrom(position);

    final id = await DbUtil.insert('places', {
      'title': title,
      'image': image.path,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    });

    final newPlace = Place(
        id: id,
        title: title,
        location: PlaceLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
        image: image);

    _items.add(newPlace);
    notifyListeners();
  }
}
