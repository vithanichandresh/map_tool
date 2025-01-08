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
    if (directoryPath != null) {
      setState(() {
        _selectedDirectory = directoryPath;
      });
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
