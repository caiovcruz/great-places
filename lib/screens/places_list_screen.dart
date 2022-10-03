import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_provider.dart';
import '../utils/app_routes.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Places'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.placeFormScreen),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder(
          future:
              Provider.of<PlacesProvider>(context, listen: false).loadPlaces(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<PlacesProvider>(
                      child: const Center(
                        child: Text('No place registered yet!'),
                      ),
                      builder: (ctx, places, child) => places.itemsCount <= 0
                          ? child!
                          : ListView.builder(
                              itemCount: places.itemsCount,
                              itemBuilder: (ctx, index) {
                                final place = places.itemByIndex(index);
                                return ListTile(
                                  onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.placeDetailScreen,
                                    arguments: place,
                                  ),
                                  leading: Hero(
                                    tag: place.id,
                                    child: FadeInImage(
                                      width: 50,
                                      height: 50,
                                      placeholder: const AssetImage(
                                          'assets/images/image-coming-soon.png'),
                                      image: FileImage(place.image),
                                      imageErrorBuilder: (context, error,
                                              stackTrace) =>
                                          Image.asset(
                                              'assets/images/image-coming-soon.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(place.title),
                                  subtitle: place.location.address != null
                                      ? Text(place.location.address!)
                                      : null,
                                );
                              },
                            ),
                    ),
        ),
      ),
    );
  }
}
