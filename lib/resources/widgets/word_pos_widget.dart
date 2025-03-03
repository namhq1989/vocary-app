import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WordPosWidget extends StatelessWidget {
  final String pos;
  final double size;

  const WordPosWidget({super.key, required this.pos, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ShadTheme.of(context).colorScheme.border.withAlpha(127),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ShadTheme.of(context).colorScheme.border.withAlpha(26),
        ),
      ),
      child: Text(pos, style: TextStyle(fontSize: size)),
    );
  }
}
