import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_tool/infrastructure/theme/theme.dart';

class AskApiKeyDialog extends StatefulWidget {
  const AskApiKeyDialog({super.key});

  @override
  State<AskApiKeyDialog> createState() => _AskApiKeyDialogState();
}

class _AskApiKeyDialogState extends State<AskApiKeyDialog> {
  String apiKey = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(

      title: const Text('API Key'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Please enter your API key'),
          const SizedBox(height: 10),
          if (Platform.isIOS || Platform.isMacOS) ...[
            CupertinoTextField(
              style: context.labelSmall,
              onChanged: (value) {
                apiKey = value;
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ] else ...[
            Material(
              child: TextField(
                style: context.labelSmall,
                onChanged: (value) {
                  apiKey = value;
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: apiKey.isNotEmpty
              ? () {
                  Navigator.of(context).pop(apiKey);
                }
              : null,
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
