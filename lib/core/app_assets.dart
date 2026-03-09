/// Single source of truth for every asset path used in Smart Farm AI.
/// Never write a raw asset path string inside a widget — reference this class.
abstract final class AppAssets {
  // ── Base paths ─────────────────────────────────────────────────────────────

  static const String _icons = 'assets/images/icons';
  static const String _images = 'assets/images';

  // ── Feature icons (SVG) ────────────────────────────────────────────────────

  static const String iconPlantDisease = '$_icons/plant_icon.svg';
  static const String iconAnimalWeight = '$_icons/animal_icon.svg';
  static const String iconCropRecommendation = '$_icons/crop_icon.svg';
  static const String iconSoilAnalysis = '$_icons/soil_icon.svg';
  static const String iconFruitQuality = '$_icons/fruit_icon.svg';
  static const String iconChatbot = '$_icons/chat_icon.svg';

  // ── General images ─────────────────────────────────────────────────────────
  // Add raster images here as the project grows, e.g.:
  // static const String splashBackground = '$_images/splash_bg.png';
}
