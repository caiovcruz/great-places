import 'package:flutter/material.dart';
import 'package:great_places/screens/map_screen.dart';

import '../models/place.dart';
import '../utils/app_routes.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)?.settings.arguments as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Hero(
              tag: place.id,
              child: FadeInImage(
                placeholder:
                    const AssetImage('assets/images/image-coming-soon.png'),
                image: FileImage(place.image),
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/image-coming-soon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            place.location.address!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MapScreen(
                  selectedLocation: place.location,
                  isReadOnly: true,
                ),
              ),
            ),
            icon: const Icon(Icons.map),
            label: const Text('See on map'),
          ),
        ],
      ),
    );
  }
}
