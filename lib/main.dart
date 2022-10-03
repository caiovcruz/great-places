import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/places_provider.dart';
import 'screens/place_detail_screen.dart';
import 'screens/place_form_screen.dart';
import 'screens/places_list_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PlacesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Great Places',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.indigo,
                secondary: Colors.amber,
              ),
        ),
        routes: {
          AppRoutes.home: (ctx) => const PlacesListScreen(),
          AppRoutes.placesListScreen: (ctx) => const PlacesListScreen(),
          AppRoutes.placeFormScreen: (ctx) => const PlaceFormScreen(),
          AppRoutes.placeDetailScreen: (ctx) => const PlaceDetailScreen(),
        },
      ),
    );
  }
}
