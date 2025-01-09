import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tool/infrastructure/helper/enums.dart';
import 'package:map_tool/infrastructure/theme/theme.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_bloc.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_events.dart';
import 'package:map_tool/interface/load_project_screen/bloc/add_map_state.dart';

class ProcessLogWidget extends StatelessWidget {
  final ScrollController scrollController;

  const ProcessLogWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMapBloc, AddMapState>(
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
      builder: (context, state) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.sdkPath.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  text: '• Flutter SDK: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: state.sdkPath,
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (state.projectPath.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  text: '• Project: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: '/Users/apple/Documents/demo/map_tool',
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (state.pugGetStatus != Status.none) ...[
              RichText(
                text: TextSpan(
                  text: '• Pug get: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: state.pugGetStatus.pubMessage,
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (state.menifiestStatus != Status.none) ...[
              RichText(
                text: TextSpan(
                  text: '• Add API to menifiest: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: state.menifiestStatus.menifiestMessage,
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (state.infoPlistStatus != Status.none) ...[
              RichText(
                text: TextSpan(
                  text: '• Add Permission to Info.plist: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: state.infoPlistStatus.infoPlistMessage,
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (state.appDelegateStatus != Status.none) ...[
              RichText(
                text: TextSpan(
                  text: '• Add API to AppDelegate.swift: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: state.appDelegateStatus.appDelegateMessage,
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (state.addSampleScreenStatus != Status.none) ...[
              RichText(
                text: TextSpan(
                  text: '• Add Sample Screen: ',
                  style: context.labelLarge,
                  children: [
                    TextSpan(
                      text: state.appDelegateStatus.appSampleMessage,
                      style: context.labelLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: context.shadowColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
            if (!state.isLoading && (state.sdkPath.isNotEmpty || state.projectPath.isNotEmpty)) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    iconColor: Colors.green,
                  ),
                  icon: Icon(Icons.refresh),
                  label: Text('Reset'),
                  onPressed: () {
                    context.read<AddMapBloc>().add(ResetState());
                  },
                ),
              ),
            ],
            if (state.isLoading) ...[
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(),
                  ),
                ),
              )
            ],
            SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
