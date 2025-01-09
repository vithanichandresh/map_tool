import 'package:equatable/equatable.dart';

abstract class AddMapEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetState extends AddMapEvents {}

class PickFlutterSdk extends AddMapEvents {}

class PickProjectPath extends AddMapEvents {}

class PubGet extends AddMapEvents {}

class ModifyAndroidMenifiest extends AddMapEvents {
  final String apiKey;

  ModifyAndroidMenifiest({required this.apiKey});

  @override
  List<Object?> get props => [apiKey];
}

class ModifyInfoPlistFile extends AddMapEvents {}

class ModifyAppDelegateFile extends AddMapEvents {
  final String? apiKey;

  ModifyAppDelegateFile({this.apiKey});

  @override
  List<Object?> get props => [apiKey];
}

class AddSampleScreen extends AddMapEvents {
  AddSampleScreen();
}
