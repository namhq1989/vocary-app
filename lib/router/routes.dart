class AppRoutes {
  // No-auth routes
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';

  // Authenticated routes (inside bottom nav)
  static const String home = '/home';
  static const String review = '/review';
  static const String profile = '/profile';

  static const String collectionDetail = '/collection/:id';

  static String onboardingUrl() => onboarding;
  static String signInUrl() => signIn;

  static String homeUrl() => home;
  static String reviewUrl() => review;
  static String profileUrl() => profile;

  static String collectionDetailUrl(String id) => '/collection/$id';
}
