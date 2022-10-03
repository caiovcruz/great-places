import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/places_provider.dart';
import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  File? _pickedImage;
  LatLng? _selectedPosition;

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  void _selectPosition(LatLng selectedPosition) {
    setState(() {
      _selectedPosition = selectedPosition;
    });
  }

  bool _isValidForm() {
    return _titleController.text.isNotEmpty &&
        _pickedImage != null &&
        _selectedPosition != null;
  }

  void _submitForm() {
    if (_isValidForm()) {
      Provider.of<PlacesProvider>(context, listen: false).addPlace(
        _titleController.text,
        _pickedImage!,
        _selectedPosition!,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('A new place has been added!'),
        duration: Duration(seconds: 2),
      ));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Place'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (title) => setState(() {}),
                      ),
                      ImageInput(onSelectImage: _selectImage),
                      LocationInput(onSelectPosition: _selectPosition),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _isValidForm() ? _submitForm : null,
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
