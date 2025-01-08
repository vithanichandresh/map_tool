import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProjectSelection extends StatefulWidget {
  const ProjectSelection({super.key});

  @override
  ProjectSelectionState createState() => ProjectSelectionState();
}

class ProjectSelectionState extends State<ProjectSelection> {
  String? _selectedDirectory;

  Future<void> _pickDirectory() async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    // check directory have pubspec.yaml file or not
    bool isPubspecFileExist = await File('$directoryPath/pubspec.yaml').exists();
    if (!isPubspecFileExist && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected directory does not contain pubspec.yaml file.')));
    }
    if (directoryPath != null) {
      _selectedDirectory = directoryPath;
      File file = File('$directoryPath/pubspec.yaml');
      String contents = await file.readAsString();
      print(contents);

      var lines = contents.split('\n');
      var dependenciesIndex = lines.indexWhere((element) => element.contains('dependencies:'));
      if (dependenciesIndex != -1) {
        lines.insert(dependenciesIndex + 1, '  google_maps_flutter: ^2.10.0');
      }
      contents = lines.join('\n');
      await file.writeAsString(contents);
      print(contents);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Project Directory'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickDirectory,
              child: Text('Pick Directory'),
            ),
            SizedBox(height: 20),
            if (_selectedDirectory != null) Text('Selected Directory: $_selectedDirectory'),
          ],
        ),
      ),
    );
  }
}
