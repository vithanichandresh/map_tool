import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tool/app/TestScreen.dart';
import 'package:map_tool/infrastructure/theme/theme.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_bloc.dart';

import '../interface/load_project_screen/project_selection.dart';

void main() async {
  /// Set minimum, maximum, and initial window size
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(Size(700, 700));
  await DesktopWindow.setWindowSize(Size(750, 750));
  await DesktopWindow.setMaxWindowSize(Size(900, 900));

  /// Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// initialize the AddMapBloc
        BlocProvider(create: (context) => AddMapBloc()),
      ],
      child: ValueListenableBuilder(
        valueListenable: mode,
        builder: (context, value, child) {
          /// This builder use for switch between dark and light theme
          return MaterialApp(
            title: 'Map Integrator',
            debugShowCheckedModeBanner: false,
            themeMode: value,
            darkTheme: AppTheme().darkTheme(context),
            theme: AppTheme().lightTheme(context),
            home: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: ProjectSelection(),
              // child: TestScreen(),
            ),
          );
        },
      ),
    );
  }
}
