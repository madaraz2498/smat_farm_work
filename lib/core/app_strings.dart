/// Single source of truth for every piece of user-visible text in Smart Farm AI.
/// Never write a raw string literal inside a widget — reference this class.
abstract final class AppStrings {
  // ── App identity ───────────────────────────────────────────────────────────

  static const String appName = 'Smart Farm AI';
  static const String appTitle = 'Smart Farm AI';

  // ── Login screen ───────────────────────────────────────────────────────────

  static const String loginTitle = 'Smart Farm AI';
  static const String loginSubtitle = 'Sign in to manage your smart farm';
  static const String loginButton = 'Sign In';
  static const String loginNoAccount = "Don't have an account? ";
  static const String loginSignUpLink = 'Sign up';

  // ── Register screen ────────────────────────────────────────────────────────

  static const String registerTitle = 'Create Account';
  static const String registerSubtitle = 'Join Smart Farm AI today';
  static const String registerButton = 'Create Account';
  static const String registerHasAccount = 'Already have an account? ';
  static const String registerSignInLink = 'Sign in';

  // ── Form field labels ──────────────────────────────────────────────────────

  static const String fieldEmail = 'Email';
  static const String fieldPassword = 'Password';
  static const String fieldConfirmPassword = 'Confirm Password';
  static const String fieldFullName = 'Full Name';
  static const String fieldRole = 'Role';

  // ── Form field hints ───────────────────────────────────────────────────────

  static const String hintEmail = 'Enter your email';
  static const String hintPassword = 'Enter your password';
  static const String hintNewPassword = 'Create a password';
  static const String hintConfirmPassword = 'Confirm your password';
  static const String hintFullName = 'Enter your full name';
  static const String hintRole = 'Select your role';

  // ── Role options ───────────────────────────────────────────────────────────

  static const List<String> roles = ['Farmer', 'Agronomist', 'Researcher', 'Admin'];

  // ── Welcome / Dashboard ────────────────────────────────────────────────────

  static const String welcomePageTitle = 'Welcome';
  static const String welcomeGreetingPrefix = 'Welcome, ';
  static const String welcomeSubtitle = 'Use AI to improve your farming decisions';

  // ── Sidebar nav labels ─────────────────────────────────────────────────────

  static const String navWelcome = 'Welcome';
  static const String navPlantDisease = 'Plant Disease Detection';
  static const String navAnimalWeight = 'Animal Weight Estimation';
  static const String navCropRecommendation = 'Crop Recommendation';
  static const String navSoilAnalysis = 'Soil Type Analysis';
  static const String navFruitQuality = 'Fruit Quality Analysis';
  static const String navChatbot = 'Smart Farm Chatbot';
  static const String navReports = 'Reports';
  static const String navSettings = 'Settings';

  // ── Bottom navigation (mobile) ─────────────────────────────────────────────

  static const String bottomNavHome = 'Home';
  static const String bottomNavPlant = 'Plant';
  static const String bottomNavAnimal = 'Animal';
  static const String bottomNavChat = 'Chat';

  // ── Feature card titles ────────────────────────────────────────────────────

  static const String featurePlantTitle = 'Plant Disease Detection';
  static const String featureAnimalTitle = 'Animal Weight Estimation';
  static const String featureCropTitle = 'Crop Recommendation';
  static const String featureSoilTitle = 'Soil Type Analysis';
  static const String featureFruitTitle = 'Fruit Quality Analysis';
  static const String featureChatTitle = 'Smart Farm Chatbot';

  // ── Feature card descriptions ──────────────────────────────────────────────

  static const String featurePlantDesc =
      'Detect plant diseases early using AI image analysis.';
  static const String featureAnimalDesc =
      'Estimate animal weight accurately without physical scales.';
  static const String featureCropDesc =
      'Get the best crop suggestions based on soil and climate data.';
  static const String featureSoilDesc =
      'Analyze soil fertility and type using data or images.';
  static const String featureFruitDesc =
      'Classify fruit quality and detect defects automatically.';
  static const String featureChatDesc =
      'Ask questions and get instant farming advice.';

  // ── Fallback / defaults ────────────────────────────────────────────────────

  static const String defaultUserName = 'John Farmer';
  static const String defaultUserRole = 'farmer';
}
