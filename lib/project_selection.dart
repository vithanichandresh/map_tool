import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:process_run/process_run.dart';

class ProjectSelection extends StatefulWidget {
  const ProjectSelection({super.key});

  @override
  ProjectSelectionState createState() => ProjectSelectionState();
}

class ProjectSelectionState extends State<ProjectSelection> {
  String? _selectedDirectory;

  Future<void> _pickDirectory() async {
    // flutter bin path
    // String? flutterDir = await FilePicker.platform.getDirectoryPath();
    // String flutterDirPath = '/${flutterDir!.split('/').sublist(3).join('/')}';
    String flutterDirPath = 'flutter';
    print('flutterDirPath: $flutterDirPath');
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    String projectDir = directoryPath!.split('/').sublist(3).join('/');
    // check directory have pubspec.yaml file or not
    bool isPubspecFileExist = await File('/$projectDir/pubspec.yaml').exists();
    if (!isPubspecFileExist && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected directory does not contain pubspec.yaml file.')),
      );
    }

    var shell = Shell();
    shell = shell.cd('/$projectDir');
    await shell.run('flutter pub get');
    await shell.run('''
      
     
      pwd
     
      # Display dart version
      dart --version
      
      # Display pub version
      flutter pub --version
            
      # Adding google_maps_flutter dependency in pubspec.yaml file
      flutter pub add google_maps_flutter
      
      # Run pub get command
      flutter pub get
    
    ''');

    String menifiestFile = '/$projectDir/android/app/src/main/AndroidManifest.xml';
    bool isMenifiestFileExist = await File(menifiestFile).exists();
    if (!isMenifiestFileExist && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('AndroidManifest.xml file does not exist in the selected directory.')));
    } else {
      // xml file read
      File file = File(menifiestFile);
      String contents = await file.readAsString();
      var lines = contents.split('\n');
      var index = lines.indexWhere((element) => element.contains('</intent-filter>'));
      bool isKeyExist = lines.any((element) => element.contains('com.google.android.geo.API_KEY'));
      if (!isKeyExist) {
        String newContents =
            """            <meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR KEY HERE"/>""";

        if (index != -1) {
          lines.insert(index + 1, newContents);
          await file.writeAsString(lines.join('\n'));
          print(contents);
        }
      }
    }

    String infoPlistFile = '/$projectDir/ios/Runner/Info.plist';
    bool isInfoPlistFileExist = await File(infoPlistFile).exists();
    if (isInfoPlistFileExist && mounted) {
      File file = File(infoPlistFile);
      String contents = await file.readAsString();
      var lines = contents.split('\n');
      var index = lines.indexWhere((element) => element.contains('<dict>'));
      bool isKeyExist = lines.any((element) => element.contains('NSLocationWhenInUseUsageDescription'));
      if (!isKeyExist) {
        String newContents = """
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs access to location when open.</string>	 
    <key>NSLocationAlwaysUsageDescription</key>
    <string>This app needs access to location when in the background.</string>""";
        lines.insert(index + 1, newContents);
        await file.writeAsString(lines.join('\n'));
        print(contents);
      }
    }

    String appDelegateFile = '/$projectDir/ios/Runner/AppDelegate.m';
    bool isAppDelegateFileExist = await File(appDelegateFile).exists();
    if (isAppDelegateFileExist && mounted) {
      File file = File(appDelegateFile);
      String contents = await file.readAsString();
      var lines = contents.split('\n');
      var index = lines.indexWhere((element) => element.contains('didFinishLaunchingWithOptions'));
      bool isKeyExist = lines.any((element) => element.contains('[GMSServices provideAPIKey:@"YOUR KEY HERE"];'));
      if (!isKeyExist) {
        String newContents = """
    "[GMSServices provideAPIKey:@"YOUR KEY HERE"];""";
        lines.insert(index + 1, newContents);
        lines.insert(0, '#import "GoogleMaps/GoogleMaps.h');
        await file.writeAsString(lines.join('\n'));
        print(contents);
      }
    }

    String swiftFile = '/$projectDir/ios/Runner/AppDelegate.swift';
    bool isSwiftFileExist = await File(swiftFile).exists();
    if (isSwiftFileExist && mounted) {
      File file = File(swiftFile);
      String contents = await file.readAsString();
      var lines = contents.split('\n');
      bool isKeyExist = lines.any((element) => element.contains('GMSServices.provideAPI("YOUR KEY HERE ")'));
      if (!isKeyExist) {
        var index = lines.indexWhere((element) => element.contains('didFinishLaunchingWithOptions'));
        String indexLine = lines[index];
        bool isItContains = indexLine.contains('{');
        if (!isItContains) {
          // find { after index
          index = lines.indexWhere((element) => element.contains('{'), index);
        }

          String newContents = """
    GMSServices.provideAPI("YOUR KEY HERE ")""";
          lines.insert(index + 1, newContents);
          lines.insert(0, 'import GoogleMaps');
          await file.writeAsString(lines.join('\n'));
          print(contents);
      }
    }

    String codeText = await rootBundle.loadString('assets/sample_map_widget.dart');
    File file = File('/$projectDir/lib/sample_map_widget.dart');
    await file.writeAsString(codeText);

    await shell.run('''
    
    cd /$projectDir
    
    # Run pub get command
    flutter pub get
    
    ''');

    _selectedDirectory = directoryPath;
    setState(() {});
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
