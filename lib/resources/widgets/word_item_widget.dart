import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/signals/word_store_signal.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/router/routes.dart';

class WordItemWidget extends StatelessWidget {
  final String wordId;

  const WordItemWidget({super.key, required this.wordId});

  @override
  Widget build(BuildContext context) {
    final word = WordStoreSignals.getWord(wordId);
    if (word == null) return const SizedBox.shrink();

    final meaning = word.definitions[0];
    String truncatedMeaning =
        meaning.length > 150 ? '${meaning.substring(0, 147)}...' : meaning;

    bool isNotLearned = !word.isMastered && word.currentStreak == 0;

    return InkWell(
      onTap: () {
        context.push(AppRoutes.wordDetailUrl(wordId));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: ShadTheme.of(context).colorScheme.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part of Speech Tags
            Row(
              children: [
                for (var pos in word.pos) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: ShadTheme.of(
                        context,
                      ).colorScheme.border.withAlpha(127),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: ShadTheme.of(
                          context,
                        ).colorScheme.border.withAlpha(26),
                      ),
                    ),
                    child: Text(pos, style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(width: 4),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Word Title
            Text(
              word.word,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.wordColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            Text(
              word.ipa,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontFamily: 'NotoSans',
              ),
            ),
            const SizedBox(height: 6),

            // Word Meaning
            Text(
              truncatedMeaning,
              style: TextStyle(fontSize: 12),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // Badges (Mastered / Not Learned / Progress)
            if (word.isMastered)
              _buildBadge('Mastered', AppColors.masteredColor)
            else if (isNotLearned)
              _buildBadge('Not Learned', Colors.grey)
            else
              _buildBadge(
                '${word.currentStreak}/${word.masteryThreshold}',
                AppColors.pointsColor,
              ),
          ],
        ),
      ),
    );
  }

  // Reusable badge widget
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
