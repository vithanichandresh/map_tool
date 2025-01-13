import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tool/infrastructure/helper/enums.dart';
import 'package:map_tool/infrastructure/theme/theme.dart';
import 'package:map_tool/interface/common/my_separator.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_bloc.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_events.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_state.dart';
import 'package:map_tool/interface/load_project_screen/process_log_widget.dart';
import 'package:map_tool/interface/load_project_screen/step_widget.dart';

import 'ask_api_key_dialog.dart';

ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

class ProjectSelection extends StatefulWidget {
  const ProjectSelection({super.key});

  @override
  ProjectSelectionState createState() => ProjectSelectionState();
}

class ProjectSelectionState extends State<ProjectSelection> {
  final ScrollController scrollController = ScrollController();
  final ScrollController processScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// AppBar (Have to set in column to give proper margin to align with the content)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppBar(
              leading: Icon(Icons.code, size: 30),
              title: const Text('Map Integrator'),
              actions: [
                TextButton.icon(
                  icon: Icon(context.isDark ? Icons.light_mode : Icons.dark_mode),
                  label: Text(context.isDark ? 'Light Mode' : 'Dark Mode'),
                  onPressed: () {
                    mode.value = context.isDark ? ThemeMode.light : ThemeMode.dark;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          /// Content Area
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor!,
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: BlocBuilder<AddMapBloc, AddMapState>(
                builder: (context, state) => Column(
                  children: [
                    /// page title and description
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Google Map Integration Simplified',
                            style: context.titleLarge,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Effortlessly add Google Maps to your Flutter projects in just three steps!',
                            style: context.bodyMedium?.copyWith(
                              color: context.shadowColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// steps 1) select flutter sdk, 2) select project directory, 3) start integrating
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// step 1: select flutter sdk
                          Expanded(
                            child: StepWidget(
                              isSelected: state.sdkPath.isEmpty,
                              isCompleted: state.sdkPath.isNotEmpty,
                              icon: Icons.folder_open,
                              title: 'Select Flutter SDK bin folder',
                              onTap: () {
                                if (!state.isLoading) {
                                  context.read<AddMapBloc>().add(PickFlutterSdk());
                                }
                              },
                            ),
                          ),

                          /// divider
                          Expanded(
                            child: state.sdkPath.isEmpty
                                ? MySeparator(
                                    color: context.dividerColor!,
                                  )
                                : Container(
                                    color: context.primaryColor,
                                    height: 1,
                                  ),
                          ),

                          /// step 2: select project directory
                          Expanded(
                            child: StepWidget(
                              isSelected: state.sdkPath.isNotEmpty && state.projectPath.isEmpty,
                              isCompleted: state.projectPath.isNotEmpty,
                              icon: Icons.code,
                              title: 'Select Project Directory',
                              onTap: () {
                                if (!state.isLoading) {
                                  context.read<AddMapBloc>().add(PickProjectPath());
                                }
                              },
                            ),
                          ),

                          /// divider
                          Expanded(
                            child: state.projectPath.isEmpty
                                ? MySeparator(
                                    color: context.dividerColor!,
                                  )
                                : Container(
                                    color: context.primaryColor,
                                    height: 1,
                                  ),
                          ),

                          /// step 3: start integrating
                          Expanded(
                            child: MultiBlocListener(
                              listeners: [
                                /// step 1: add api key in AndroidManifest.xml
                                BlocListener<AddMapBloc, AddMapState>(
                                  listenWhen: (previous, current) {
                                    return previous.pugGetStatus != current.pugGetStatus;
                                  },
                                  listener: (context, state) async {
                                    if (state.pugGetStatus == Status.completed) {
                                      final result = await showAdaptiveDialog(
                                        context: context,
                                        builder: (context) {
                                          return AskApiKeyDialog();
                                        },
                                      );
                                      if (result is String && result.isNotEmpty && context.mounted) {
                                        context.read<AddMapBloc>().add(ModifyAndroidMenifiest(apiKey: result));
                                      }
                                    }
                                  },
                                ),

                                /// step 2: add location permission in Info.plist
                                BlocListener<AddMapBloc, AddMapState>(
                                  listenWhen: (previous, current) {
                                    return previous.menifiestStatus != current.menifiestStatus;
                                  },
                                  listener: (context, state) {
                                    if (state.menifiestStatus == Status.completed) {
                                      context.read<AddMapBloc>().add(ModifyInfoPlistFile());
                                    }
                                  },
                                ),

                                /// step 3: add api key in appDelegate.swift
                                BlocListener<AddMapBloc, AddMapState>(
                                  listenWhen: (previous, current) {
                                    return previous.infoPlistStatus != current.infoPlistStatus;
                                  },
                                  listener: (context, state) {
                                    if (state.infoPlistStatus == Status.completed) {
                                      context.read<AddMapBloc>().add(ModifyAppDelegateFile());
                                    }
                                  },
                                ),

                                /// step 4: add api key in appDelegate.m
                                BlocListener<AddMapBloc, AddMapState>(
                                  listenWhen: (previous, current) {
                                    return previous.appDelegateStatus != current.appDelegateStatus;
                                  },
                                  listener: (context, state) {
                                    if (state.appDelegateStatus == Status.completed) {
                                      context.read<AddMapBloc>().add(AddSampleScreen());
                                    }
                                  },
                                ),
                              ],
                              child: StepWidget(
                                isSelected: state.projectPath.isNotEmpty && state.sdkPath.isNotEmpty,
                                isCompleted: state.addSampleScreenStatus == Status.completed,
                                isLoading: state.isLoading,
                                icon: Icons.play_arrow,
                                title: 'Start Integrating',
                                onTap: () {
                                  if (!state.isLoading) {
                                    context.read<AddMapBloc>().add(PubGet());
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// error message
                    if (state.errorMessage.isNotEmpty) ...[
                      BlocListener<AddMapBloc, AddMapState>(
                        listenWhen: (previous, current) {
                          return previous.errorMessage != current.errorMessage;
                        },
                        listener: (context, state) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            // scroll to end
                            if (scrollController.hasClients) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                              );
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: context.errorColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Scrollbar(
                            controller: scrollController,
                            trackVisibility: false,
                            interactive: false,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Text(
                                state.errorMessage,
                                style: context.labelLarge?.copyWith(color: context.errorColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 10),

                    /// process log and reset button
                    Expanded(
                      child: ProcessLogWidget(scrollController: processScrollController),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
