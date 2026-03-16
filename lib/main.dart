import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/auth_page.dart';
import 'controllers/theme_controller.dart';

class AppColors {
  static const cream = Color(0xFFF5F0E8);
  static const sageGreen = Color(0xFF8A9E7E);
  static const sageGreenLight = Color(0xFFB5C4AB);
  static const sageGreenDark = Color(0xFF3D4A35);
  static const warmBrown = Color(0xFF6B4F3A);
  static const warmBrownLight = Color(0xFFD4C4B0);
  static const textDark = Color(0xFF2C2C2C);
  static const textMuted = Color(0xFF7A7A6E);

  static const darkBg = Color(0xFF1A1F18);
  static const darkSurface = Color(0xFF252B22);
  static const darkCard = Color(0xFF2E3529);
  static const darkSageGreen = Color(0xFF8A9E7E);
  static const darkSageGreenLight = Color(0xFF4A5C42);
  static const darkWarmBrown = Color(0xFFB89070);
  static const darkWarmBrownLight = Color(0xFF4A3D30);
  static const darkTextPrimary = Color(0xFFEDE8DF);
  static const darkTextMuted = Color(0xFF9A9A8A);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  print('URL: ${dotenv.env['SUPABASE_URL']}');
  print('KEY: ${dotenv.env['SUPABASE_ANON_KEY']}');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        title: 'Personal Blog',
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: themeController.themeMode,
        home: const AuthGate(),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: const ColorScheme.light(
        primary: AppColors.sageGreen,
        secondary: AppColors.warmBrown,
        surface: AppColors.cream,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textDark,
      ),
      textTheme: GoogleFonts.rubikTextTheme().apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sageGreenDark,
          foregroundColor: AppColors.cream,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.sageGreenDark,
        foregroundColor: AppColors.cream,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.warmBrownLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.warmBrownLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.warmBrownLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.sageGreen, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
      ),
      dividerColor: AppColors.warmBrownLight,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.sageGreenDark,
        contentTextStyle: TextStyle(color: AppColors.cream),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkSageGreen,
        secondary: AppColors.darkWarmBrown,
        surface: AppColors.darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      textTheme: GoogleFonts.rubikTextTheme().apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkSageGreen,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkSageGreen,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.darkWarmBrownLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkWarmBrownLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkWarmBrownLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.darkSageGreen,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(color: AppColors.darkTextMuted),
      ),
      dividerColor: AppColors.darkWarmBrownLight,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        contentTextStyle: TextStyle(color: AppColors.darkTextPrimary),
      ),
    );
  }
}
