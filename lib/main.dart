import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/auth_service.dart';
import 'services/matching_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';

// Define custom colors
class LumeColors {
  static const MaterialColor sand = MaterialColor(
    0xFFE8E6E1, // Primary sand color
    <int, Color>{
      50: Color(0xFFFAF9F7),
      100: Color(0xFFF5F3F0),
      200: Color(0xFFEFECE8),
      300: Color(0xFFE8E6E1), // Main brand color
      400: Color(0xFFD8D6D3),
      500: Color(0xFFC8C6C3),
      600: Color(0xFFB8B6B3),
      700: Color(0xFFA8A6A3),
      800: Color(0xFF989693),
      900: Color(0xFF787673),
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fhorwkmnlrijxkodkwcx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZob3J3a21ubHJpanhrb2Rrd2N4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxNDM5NDksImV4cCI6MjA0ODcxOTk0OX0.b6PWrxywkjCO-zI9bhT9qL_jgNl9anqUATbGeMUOobM',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<MatchingService>(
            create: (_) => MatchingService()),
      ],
      child: MaterialApp(
        title: 'Lumé Dating App',
        theme: ThemeData(
          primarySwatch: LumeColors.sand,
          primaryColor: LumeColors.sand[300],
          scaffoldBackgroundColor: LumeColors.sand[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE8E6E1),
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: LumeColors.sand[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: LumeColors.sand[600]!),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return authService.isAuthenticated ? HomeScreen() : LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/signup': (context) => SignUpScreen(),
        },
      ),
    );
  }
}
