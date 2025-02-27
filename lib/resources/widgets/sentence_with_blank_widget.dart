import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SentenceWithBlankWidget extends StatelessWidget {
  final String sentence;
  final String wordToBlank;
  final double blankWidth;
  final TextStyle textStyle;

  const SentenceWithBlankWidget({
    super.key,
    required this.sentence,
    required this.wordToBlank,
    this.blankWidth = 80.0,
    this.textStyle = const TextStyle(fontSize: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    // Split the sentence into parts before and after the word to blank
    List<String> parts = _splitSentenceAtWord(sentence, wordToBlank);

    return RichText(
      text: TextSpan(
        style: textStyle,
        children: [
          TextSpan(
            text: parts[0],
            style: TextStyle(color: ShadTheme.of(context).textTheme.p.color),
          ),
          WidgetSpan(
            child: Container(
              width: blankWidth,
              height: 2,
              color: ShadTheme.of(context).textTheme.p.color!.withAlpha(150),
              margin: EdgeInsets.only(bottom: 4.0),
            ),
          ),
          TextSpan(
            text: parts[1],
            style: TextStyle(color: ShadTheme.of(context).textTheme.p.color),
          ),
        ],
      ),
    );
  }

  List<String> _splitSentenceAtWord(String sentence, String word) {
    // Case-insensitive search
    String lowerSentence = sentence.toLowerCase();
    String lowerWord = word.toLowerCase();

    int index = lowerSentence.indexOf(lowerWord);

    if (index == -1) {
      // Word not found
      return [sentence, ""];
    }

    String before = sentence.substring(0, index);
    String after = sentence.substring(index + word.length);

    return [before, after];
  }
}
