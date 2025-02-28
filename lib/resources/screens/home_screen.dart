import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vocary/app/controllers/home_controller.dart';
import 'package:vocary/app/models/collection.dart';
import 'package:vocary/app/models/daily_points.dart';
import 'package:vocary/app/models/quote.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/practice_config_bottom_sheet.dart';
import 'package:vocary/resources/widgets/word_item_widget.dart';
import 'package:vocary/resources/widgets/word_of_the_day_widget.dart';
import 'package:vocary/router/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TooltipBehavior? _tooltipBehavior;
  final int dailyGoal = 200;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );

    HomeController.fetchRandomWords();
  }

  final List<Collection> collections = [
    Collection(
      name: 'Random',
      description: 'Random words from all collections',
      icon: LucideIcons.shuffle,
      totalWords: 100,
    ),
    Collection(
      name: 'Beginner',
      description: 'Basic words for daily conversation',
      icon: LucideIcons.baby,
      totalWords: 50,
    ),
    Collection(
      name: 'Intermediate',
      description: 'Common words for fluent speaking',
      icon: LucideIcons.graduationCap,
      totalWords: 100,
    ),
    Collection(
      name: 'Advanced',
      description: 'Advanced words for professional use',
      icon: LucideIcons.trophy,
      totalWords: 150,
    ),
  ];

  final Quote quote = Quote(
    text: "The limits of my language mean the limits of my world.",
    author: "Ludwig Wittgenstein",
  );

  final List<DailyPoints> weeklyPoints = [
    DailyPoints(date: DateTime(2025, 2, 15), points: 120), // Sat
    DailyPoints(date: DateTime(2025, 2, 16), points: 80), // Sun
    DailyPoints(date: DateTime(2025, 2, 17), points: 0), // Mon
    DailyPoints(date: DateTime(2025, 2, 18), points: 90), // Tue
    DailyPoints(date: DateTime(2025, 2, 19), points: 200), // Wed
    DailyPoints(date: DateTime(2025, 2, 20), points: 0), // Thu
    DailyPoints(date: DateTime(2025, 2, 21), points: 150), // Fri (Today)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildStatsLine(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDailyProgress(context),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuoteSection(),
                        const SizedBox(height: 32),
                        _buildCollectionsSection(context),
                        const SizedBox(height: 32),
                        const WordOfTheDayWidget(),
                        const SizedBox(height: 32),
                        _buildRandomWordsSection(),
                        const SizedBox(height: 32),
                        _buildPointsChart(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context: context,
            icon: LucideIcons.star,
            iconColor: AppColors.pointsColor,
            value: '1,250',
            label: 'Points',
          ),
          _buildStatItem(
            context: context,
            icon: LucideIcons.library,
            iconColor: AppColors.learnedColor,
            value: '48',
            label: 'Learned',
          ),
          _buildStatItem(
            context: context,
            icon: LucideIcons.trophy,
            iconColor: AppColors.masteredColor,
            value: '24',
            label: 'Mastered',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(label, style: TextStyle(fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote.text,
            style: ShadTheme.of(
              context,
            ).textTheme.blockquote.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            '- ${quote.author}',
            style: ShadTheme.of(context).textTheme.lead.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Collections', style: ShadTheme.of(context).textTheme.h3),
          const SizedBox(height: 16),
          ...collections.map(
            (collection) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildCollectionItem(context, collection),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(BuildContext context, Collection collection) {
    Color backgroundColor;
    Color textColor;

    switch (collection.name.toLowerCase()) {
      case 'beginner':
        backgroundColor = AppColors.pointsColor.withAlpha(26);
        textColor = AppColors.pointsColor;
        break;
      case 'intermediate':
        backgroundColor = AppColors.masteredColor.withAlpha(26);
        textColor = AppColors.masteredColor;
        break;
      case 'advanced':
        backgroundColor = AppColors.learnedColor.withAlpha(26);
        textColor = AppColors.learnedColor;
        break;
      default:
        backgroundColor = ShadTheme.of(
          context,
        ).colorScheme.primary.withAlpha(26);
        textColor = ShadTheme.of(context).colorScheme.primary;
    }

    return InkWell(
      onTap: () => {context.push(AppRoutes.collectionDetailUrl('123'))},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: ShadTheme.of(context).colorScheme.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(collection.icon, color: textColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    collection.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    collection.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '10',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '/${collection.totalWords}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Text('words', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => {showPracticeConfigBottomSheet(context)},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Practice Now',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomWordsSection() {
    return Watch((context) {
      final isFetching = HomeController.isFetchingRandomWords.value;
      final randomWords = HomeController.randomWords.value;

      if (isFetching) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Random Words',
              style: ShadTheme.of(context).textTheme.h3,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: randomWords.length.clamp(0, 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ), // Ensures padding
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left:
                        index == 0
                            ? 0
                            : 8, // First item meets left edge, others have 8px gap
                    right:
                        index == randomWords.length - 1
                            ? 0
                            : 8, // Last item meets right edge
                  ),
                  child: SizedBox(
                    width: 160, // Adjust width for a single word card
                    child: WordItemWidget(wordId: randomWords[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  String _getDayName(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayIndex = date.weekday - 1; // weekday returns 1-7 for Mon-Sun
    return days[dayIndex];
  }

  Widget _buildDailyProgress(BuildContext context) {
    final today = weeklyPoints.last;

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Progress', style: ShadTheme.of(context).textTheme.h4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ShadTheme.of(
                    context,
                  ).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '75% completed',
                  style: ShadTheme.of(context).textTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              // Background progress bar
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: ShadTheme.of(
                    context,
                  ).colorScheme.primaryForeground.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: ShadTheme.of(context).colorScheme.border,
                  ),
                ),
              ),
              // Progress indicator
              FractionallySizedBox(
                widthFactor: (today.points / dailyGoal).clamp(0.0, 1.0),
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Points display
              SizedBox(
                height: 32,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${today.points}',
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                          color:
                              ShadTheme.of(
                                context,
                              ).colorScheme.primaryForeground,
                        ),
                      ),
                      Text(
                        '$dailyGoal',
                        style: ShadTheme.of(context).textTheme.small,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Points History', style: ShadTheme.of(context).textTheme.h3),
          const SizedBox(height: 16),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
            child: Stack(
              children: [
                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: TextStyle(fontSize: 13),
                  ),
                  primaryYAxis: const NumericAxis(isVisible: false),
                  legend: const Legend(isVisible: false),
                  tooltipBehavior: _tooltipBehavior,
                  series: <CartesianSeries<DailyPoints, String>>[
                    ColumnSeries<DailyPoints, String>(
                      dataSource: weeklyPoints,
                      color: ShadTheme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      width: 0.5,
                      xValueMapper:
                          (DailyPoints point, _) => _getDayName(point.date),
                      yValueMapper: (DailyPoints point, _) => point.points,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Container(height: 250, color: Colors.transparent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
