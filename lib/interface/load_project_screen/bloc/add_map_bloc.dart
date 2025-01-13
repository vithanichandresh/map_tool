import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tool/infrastructure/helper/enums.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_events.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_state.dart';
import 'package:process_run/process_run.dart';

class AddMapBloc extends Bloc<AddMapEvents, AddMapState> {
  AddMapBloc() : super(AddMapState()) {
    on<ResetState>(onResetState);
    on<PickFlutterSdk>(onPickFlutterSdk);
    on<PickProjectPath>(onPickProjectPath);
    on<PubGet>(onPubGet);
    on<ModifyAndroidMenifiest>(onModifyAndroidMenifiest);
    on<ModifyInfoPlistFile>(onModifyInfoPlistFile);
    on<ModifyAppDelegateFile>(onModifyAppDelegateFile);
    on<AddSampleScreen>(onAddSampleScreen);
  }

  FutureOr<void> onResetState(ResetState event, Emitter<AddMapState> emit) async {
    emit(AddMapState());
  }

  FutureOr<void> onPickFlutterSdk(PickFlutterSdk event, Emitter<AddMapState> emit) async {
    String flutterDirPath = '';
    emit(
      state.copyWith(
        errorMessage: '',
        isLoading: false,
        resetStatus: true,
        sdkPath: '',
      ),
    );
    String? directoryPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Navigate to the Flutter directory and then enter the bin folder.',
    );
    if (directoryPath != null) {
      if(Platform.isMacOS) {
        int i = directoryPath.indexOf('/Users');
        if(i > -1) {
          directoryPath = directoryPath.substring(i);
        }
      }
      File file = File('$directoryPath/flutter');
      if (await file.exists()) {
        flutterDirPath = '$directoryPath/flutter';
      } else {
        emit(state.copyWith(errorMessage: 'Invalid Flutter SDK path'));
      }
    }
    emit(state.copyWith(sdkPath: flutterDirPath));
  }

  FutureOr<void> onPickProjectPath(PickProjectPath event, Emitter<AddMapState> emit) async {
    String projectPath = '';
    emit(state.copyWith(errorMessage: '', isLoading: false, resetStatus: true));
    String? directoryPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Navigate to the Flutter project directory.',
    );
    if (directoryPath != null) {
      if(Platform.isMacOS) {
        int i = directoryPath.indexOf('/Users');
        if(i > -1) {
          directoryPath = directoryPath.substring(i);
        }
      }
      File file = File('$directoryPath/pubspec.yaml');
      if (await file.exists()) {
        projectPath = directoryPath;
      } else {
        emit(state.copyWith(errorMessage: 'Invalid project path'));
      }
    }
    emit(state.copyWith(projectPath: projectPath));
  }

  FutureOr<void> onPubGet(PubGet event, Emitter<AddMapState> emit) async {
    try {
      if (state.sdkPath.isNotEmpty && state.projectPath.isNotEmpty) {
        emit(state.copyWith(isLoading: true, pugGetStatus: Status.start, errorMessage: ''));
        String sdk = state.sdkPath;
        String projectDir = state.projectPath;
        var shell = Shell();
        shell = shell.cd(projectDir);
        await shell.run('$sdk pub add google_maps_flutter');
        await shell.run('$sdk pub get');
        shell.kill();
        emit(state.copyWith(isLoading: false, pugGetStatus: Status.completed, errorMessage: ''));
      }
    } on ShellException catch (e) {
      List<String> lines = e.result?.errLines.toList() ?? [];
      lines.removeWhere((element) => element.trim().isEmpty);
      String errorMessage = lines.join('\n');
      emit(state.copyWith(errorMessage: errorMessage, pugGetStatus: Status.failed, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), pugGetStatus: Status.failed, isLoading: false));
    }
  }

  FutureOr<void> onModifyAndroidMenifiest(ModifyAndroidMenifiest event, Emitter<AddMapState> emit) async {
    try {
      emit(state.copyWith(apiKey: event.apiKey, isLoading: true, menifiestStatus: Status.start, errorMessage: ''));
      String path = '${state.projectPath}/android/app/src/main/AndroidManifest.xml';
      String content = """
        <meta-data 
            android:name="com.google.android.geo.API_KEY" 
            android:value="${event.apiKey}"/>
      """;
      final manifestFile = File(path);
      if (await manifestFile.exists()) {
        String manifestContent = await manifestFile.readAsString();

        // Find the <application> tag
        final applicationTagRegex = RegExp(r'</application[^>]*>');
        final applicationTagMatch = applicationTagRegex.firstMatch(manifestContent);
        if (applicationTagMatch != null) {
          bool isKeyExist = manifestContent.contains('com.google.android.geo.API_KEY');
          if (!isKeyExist) {
            // Insert the tag before the closing </application> tag
            final insertIndex = applicationTagMatch.start;
            String upperLines = manifestContent.substring(0, insertIndex);
            String belowLines = manifestContent.substring(insertIndex);
            String newString = '$upperLines'
                '\n$content\n'
                '$belowLines';
            await manifestFile.writeAsString(newString);
          }
          await Future.delayed(Duration(seconds: 2));
          emit(state.copyWith(errorMessage: '', menifiestStatus: Status.completed, isLoading: false));
        } else {
          emit(state.copyWith(errorMessage: 'Failed to update AndroidManifest.xml', menifiestStatus: Status.failed));
        }
      } else {
        emit(state.copyWith(
            errorMessage: 'AndroidManifest.xml not found', menifiestStatus: Status.failed, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), menifiestStatus: Status.failed, isLoading: false));
    }
  }

  FutureOr<void> onModifyInfoPlistFile(ModifyInfoPlistFile event, Emitter<AddMapState> emit) async {
    emit(state.copyWith(isLoading: true, infoPlistStatus: Status.start, errorMessage: ''));
    try {
      String plistPath = '${state.projectPath}/ios/Runner/Info.plist';
      bool isPlistPathExist = await File(plistPath).exists();
      if (isPlistPathExist) {
        File file = File(plistPath);
        String line = """
          <key>NSLocationWhenInUseUsageDescription</key>
          <string>This app needs access to location when open.</string>
          <key>NSLocationAlwaysUsageDescription</key>
          <string>This app needs access to location when in the background.</string>""";

        String fileContent = file.readAsStringSync();
        final lineRegX = RegExp(r'NSLocationWhenInUseUsageDescription');
        bool isLineExist = lineRegX.hasMatch(fileContent);
        if (!isLineExist) {
          final methodRegex = RegExp(r'</dict>');
          final methodMatch = methodRegex.firstMatch(fileContent);
          if (methodMatch != null) {
            final insertIndex = methodMatch.start;
            String upperLines = fileContent.substring(0, insertIndex);
            String belowLines = fileContent.substring(insertIndex);
            String newString = '$upperLines'
                '$line\n'
                '$belowLines';
            await file.writeAsString(newString);
          }
        }
        await Future.delayed(Duration(seconds: 2));
        emit(state.copyWith(errorMessage: '', infoPlistStatus: Status.completed, isLoading: false));
      } else {
        emit(state.copyWith(errorMessage: 'Info.plist not found', infoPlistStatus: Status.failed, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), infoPlistStatus: Status.failed, isLoading: false));
    }
  }

  FutureOr<void> onModifyAppDelegateFile(ModifyAppDelegateFile event, Emitter<AddMapState> emit) async {
    emit(state.copyWith(apiKey: event.apiKey, isLoading: true, appDelegateStatus: Status.start, errorMessage: ''));
    try {
      String swiftPath = '${state.projectPath}/ios/Runner/AppDelegate.swift';
      bool isAppDelegateSwiftFileExist = await File(swiftPath).exists();
      if (isAppDelegateSwiftFileExist) {
        File appDelegateSwiftFile = File(swiftPath);
        String importString = 'import GoogleMaps';
        String line = """
    GMSServices.provideAPIKey("${state.apiKey}")
      """;
        String fileContent = await appDelegateSwiftFile.readAsString();

        final lineRegX = RegExp(r'GMSServices.provideAPIKey');
        bool isLineExist = lineRegX.hasMatch(fileContent);
        if (!isLineExist) {
          bool isImportExist = fileContent.contains(importString);
          if (!isImportExist) {
            fileContent = ''
                '$importString\n'
                '$fileContent';
            await appDelegateSwiftFile.writeAsString(fileContent);
          }

          // Find the didFinishLaunchingWithOptions method
          final methodRegex = RegExp(r'GeneratedPluginRegistrant');
          final methodMatch = methodRegex.firstMatch(fileContent);
          if (methodMatch == null) {
            throw Exception('didFinishLaunchingWithOptions method not found in AppDelegate.swift');
          }

          // Insert the line after the method signature
          final insertIndex = methodMatch.start;
          String upperLine = fileContent.substring(0, insertIndex);
          String belowLine = fileContent.substring(insertIndex);
          String newString = '$upperLine'
              '$line'
              '$belowLine';

          // Write the modified content back to the file
          await appDelegateSwiftFile.writeAsString(newString);
        }
        await Future.delayed(Duration(seconds: 2));
        emit(state.copyWith(errorMessage: '', appDelegateStatus: Status.completed, isLoading: false));
      } else {
        emit(state.copyWith(
            errorMessage: 'AppDelegate.swift not found', appDelegateStatus: Status.failed, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), appDelegateStatus: Status.failed, isLoading: false));
    }
  }

  FutureOr<void> onAddSampleScreen(AddSampleScreen event, Emitter<AddMapState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, addSampleScreenStatus: Status.start, errorMessage: ''));
      String codeText = await rootBundle.loadString('assets/sample_map_widget.dart');
      File file = File('${state.projectPath}/lib/sample_map_widget.dart');
      await file.writeAsString(codeText);

      Shell shell = Shell();
      shell = shell.cd(state.projectPath);
      await shell.run('flutter pub get');
      shell.kill();
      emit(state.copyWith(isLoading: false, addSampleScreenStatus: Status.completed, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), addSampleScreenStatus: Status.failed, isLoading: false));
    }
  }
}
