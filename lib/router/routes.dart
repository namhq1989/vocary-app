class AppRoutes {
  // No-auth routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';

  // Authenticated routes (inside bottom nav)
  static const String home = '/home';
  static const String review = '/review';
  static const String profile = '/profile';

  static const String collectionDetail = '/collection/:id';
  static const String collectionListWords = '/collection/:id/words';
  static const String wordDetail = '/word/:id';
  static const String practice = '/practice';

  static String splashUrl() => '/splash';
  static String onboardingUrl() => onboarding;
  static String signInUrl() => signIn;

  static String homeUrl() => home;
  static String reviewUrl() => review;
  static String profileUrl() => profile;

  static String collectionDetailUrl(String id) => '/collection/$id';
  static String collectionListWordsUrl(String id) => '/collection/$id/words';
  static String wordDetailUrl(String id) => '/word/$id';
  static String practiceUrl() => '/practice';
}
