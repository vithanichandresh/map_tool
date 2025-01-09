import 'package:flutter/material.dart';
import 'package:map_tool/infrastructure/theme/theme.dart';

class StepWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool isSelected;
  final bool isCompleted;
  final bool isLoading;

  const StepWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
    required this.isCompleted,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? cardColor = context.cardColor;
    Color? textColor = context.dividerColor;
    if (isSelected || isCompleted) {
      cardColor = context.primaryColor?.withOpacity(.1);
      textColor = context.primaryColor;
    } else {
      cardColor = context.cardColor;
      textColor = context.dividerColor;
    }
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor!, width: 1),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: 40,
                ),
                SizedBox(height: 5),
                Flexible(
                  child: Text(
                    title,
                    style: context.labelLarge?.copyWith(
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              if(isLoading)...[
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                  ),
                ),
              ]
              else if(isCompleted)...[
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.check_circle, color: textColor, size: 20),
                ),
              ]
              else...[
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: textColor,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
