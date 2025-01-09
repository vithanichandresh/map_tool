import 'package:equatable/equatable.dart';
import 'package:map_tool/infrastructure/helper/enums.dart';

class AddMapState extends Equatable {
  final bool isLoading;
  final String sdkPath;
  final String projectPath;
  final String errorMessage;
  final String apiKey;

  final Status pugGetStatus;
  final Status menifiestStatus;
  final Status infoPlistStatus;
  final Status appDelegateStatus;
  final Status addSampleScreenStatus;

  const AddMapState({
    this.isLoading = false,
    this.sdkPath = '',
    this.projectPath = '',
    this.apiKey = '',
    this.errorMessage = '',
    this.pugGetStatus = Status.none,
    this.menifiestStatus = Status.none,
    this.infoPlistStatus = Status.none,
    this.appDelegateStatus = Status.none,
    this.addSampleScreenStatus = Status.none,
  });

  AddMapState copyWith({
    bool? isLoading,
    String? sdkPath,
    String? projectPath,
    String? apiKey,
    String? errorMessage,
    Status? pugGetStatus,
    Status? menifiestStatus,
    Status? infoPlistStatus,
    Status? appDelegateStatus,
    Status? addSampleScreenStatus,
    bool resetStatus = false,
  }) {
    if(resetStatus){
      pugGetStatus = Status.none;
      menifiestStatus = Status.none;
      infoPlistStatus = Status.none;
      appDelegateStatus = Status.none;
      addSampleScreenStatus = Status.none;
    }
    return AddMapState(
      isLoading: isLoading ?? this.isLoading,
      sdkPath: sdkPath ?? this.sdkPath,
      projectPath: projectPath ?? this.projectPath,
      errorMessage: errorMessage ?? this.errorMessage,
      apiKey: apiKey ?? this.apiKey,
      pugGetStatus: pugGetStatus ?? this.pugGetStatus,
      menifiestStatus: menifiestStatus ?? this.menifiestStatus,
      infoPlistStatus: infoPlistStatus ?? this.infoPlistStatus,
      appDelegateStatus: appDelegateStatus ?? this.appDelegateStatus,
      addSampleScreenStatus: addSampleScreenStatus ?? this.addSampleScreenStatus,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        sdkPath,
        projectPath,
        errorMessage,
        apiKey,
        pugGetStatus,
        menifiestStatus,
        infoPlistStatus,
        appDelegateStatus,
        addSampleScreenStatus,
      ];
}
