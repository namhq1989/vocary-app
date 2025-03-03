import 'package:flutter/material.dart';

class WordIpaWidget extends StatelessWidget {
  final String ipa;
  final double size;

  const WordIpaWidget({super.key, required this.ipa, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Text(
      ipa,
      style: TextStyle(
        fontSize: size,
        // fontStyle: FontStyle.italic,
        fontFamily: 'NotoSans',
      ),
    );
  }
}
