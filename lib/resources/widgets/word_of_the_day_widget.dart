import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/core/design.dart';

class WordOfTheDayWidget extends StatelessWidget {
  const WordOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Word of the Day', style: ShadTheme.of(context).textTheme.h3),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flutter',
                            style: ShadTheme.of(
                              context,
                            ).textTheme.h4.copyWith(color: AppColors.wordColor),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '/ˈflʌtər/',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'NotoSans',
                              color: ShadTheme.of(
                                context,
                              ).textTheme.p.color!.withAlpha(200),
                            ),
                          ),
                          const SizedBox(height: 6),
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
                            child: Text('noun', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ShadTheme.of(
                          context,
                        ).colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Advanced',
                        style: ShadTheme.of(context).textTheme.small,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Lasting for a very short time',
                  style: TextStyle(
                    fontSize: 15,
                    color: ShadTheme.of(
                      context,
                    ).textTheme.p.color!.withAlpha(200),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '"The ephemeral nature of social media trends makes it difficult to predict what will be popular next week"',
                  style: ShadTheme.of(context).textTheme.blockquote,
                ),
                const SizedBox(height: 12),
                Text(
                  'Synonyms: temporary, fleeting, transient, momentary',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
