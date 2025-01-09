enum Status { none, start, completed, failed }

extension Message on Status {
  String get pubMessage {
    switch (this) {
      case Status.none:
        return '';
      case Status.start:
        return 'Running pub get';
      case Status.completed:
        return 'Pub get completed';
      case Status.failed:
        return 'Pub get failed';
    }
  }

  String get menifiestMessage {
    switch (this) {
      case Status.none:
        return '';
      case Status.start:
        return 'Adding API key to AndroidManifest.xml';
      case Status.completed:
        return 'AndroidManifest.xml updated';
      case Status.failed:
        return 'Failed to update AndroidManifest.xml';
    }
  }

  String get infoPlistMessage {
    switch (this) {
      case Status.none:
        return '';
      case Status.start:
        return 'Adding permissions to Info.plist';
      case Status.completed:
        return 'Info.plist updated';
      case Status.failed:
        return 'Failed to update Info.plist';
    }
  }

  String get appDelegateMessage {
    switch (this) {
      case Status.none:
        return '';
      case Status.start:
        return 'Adding API key to AppDelegate.swift';
      case Status.completed:
        return 'AppDelegate.swift updated';
      case Status.failed:
        return 'Failed to update AppDelegate.swift';
    }
  }

  String get appSampleMessage {
    switch (this) {
      case Status.none:
        return '';
      case Status.start:
        return 'Adding sample screen to project';
      case Status.completed:
        return 'Sample screen added';
      case Status.failed:
        return 'Failed to add sample screen';
    }
  }
}
