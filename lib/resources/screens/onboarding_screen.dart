import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/onboarding_item.dart';
import 'package:vocary/router/routes.dart';

final List<OnboardingItem> _pages = [
  OnboardingItem(
    title: 'Welcome to Vocary',
    description:
        'Your personal vocabulary learning companion that helps you master new words effortlessly. Start your journey to expand your vocabulary today!',
    image: 'assets/images/onboarding-1.svg',
  ),
  OnboardingItem(
    title: 'Learn New Words Daily',
    description:
        'Challenge yourself with daily word exercises tailored to your level. Our smart algorithm adapts to your learning pace and helps you retain new vocabulary effectively.',
    image: 'assets/images/onboarding-2.svg',
  ),
  OnboardingItem(
    title: 'Track Your Progress',
    description:
        'Monitor your learning journey with detailed statistics and insights. Watch your vocabulary grow as you complete daily challenges and master new words.',
    image: 'assets/images/onboarding-3.svg',
  ),
  OnboardingItem(
    title: 'Practice Anywhere',
    description:
        'Take your learning on the go with our mobile-friendly interface. Whether you\'re commuting or relaxing, improve your vocabulary whenever and wherever you want.',
    image: 'assets/images/onboarding-4.svg',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),
                _buildPageIndicator(),
                SafeArea(child: _buildNavigationButtons()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem page) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              page.title,
              style: ShadTheme.of(context).textTheme.h2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
            child: SizedBox(
              height: 300,
              width: 300,
              child: SvgPicture.asset(page.image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              page.description,
              style: ShadTheme.of(context).textTheme.list,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:
                  _currentPage == index
                      ? ShadTheme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShadButton(
            width: double.infinity,
            child: Text(_currentPage < _pages.length - 1 ? 'Next' : 'Start'),
            onPressed: () {
              if (_currentPage < _pages.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              } else {
                context.go(AppRoutes.signInUrl());
              }
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child:
                _currentPage < _pages.length - 1
                    ? Center(
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _pages.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          'Skip',
                          style: ShadTheme.of(context).textTheme.p,
                        ),
                      ),
                    )
                    : null,
          ),
        ],
      ),
    );
  }
}
