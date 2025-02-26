import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/practice_config.dart';
import 'package:vocary/router/router.dart';
import 'package:vocary/router/routes.dart';

void showPracticeConfigBottomSheet(BuildContext context) {
  int selectedWordCount = 5;
  AnswerMethod selectedMethod = AnswerMethod.multipleChoice;

  final wordCountOptions = [3, 5, 10, 20];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final theme = ShadTheme.of(context);

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Intermediate",
                    style: theme.textTheme.h3,
                    textAlign: TextAlign.start,
                  ),
                ),
                Center(
                  child: Text(
                    "Settings",
                    style: theme.textTheme.muted.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Text("Number of Words", style: theme.textTheme.table),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      wordCountOptions.map((count) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 64) / 2,
                          child: ShadRadioGroup<int>(
                            initialValue: selectedWordCount,
                            onChanged:
                                (value) =>
                                    setState(() => selectedWordCount = value!),
                            items: [
                              ShadRadio(
                                label: Text(
                                  "$count Words",
                                  style: theme.textTheme.small,
                                ),
                                value: count,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
                Text("Answer Method", style: theme.textTheme.table),
                const SizedBox(height: 8),
                Row(
                  children:
                      AnswerMethod.values.map((method) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ShadRadioGroup<AnswerMethod>(
                              initialValue: selectedMethod,
                              onChanged:
                                  (value) =>
                                      setState(() => selectedMethod = value!),
                              items: [
                                ShadRadio(
                                  label: Text(
                                    method == AnswerMethod.multipleChoice
                                        ? "Multiple Choice"
                                        : "Text Input",
                                    style: theme.textTheme.small,
                                  ),
                                  value: method,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    ShadButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          AppRouter.router.push(AppRoutes.practiceUrl());
                        });
                      },
                      child: const Text("Start"),
                    ),
                    const SizedBox(height: 4),
                    ShadButton.outline(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
