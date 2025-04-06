import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:krishi/screens/splash_screen.dart';
import 'generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/main_screen_state.dart';
import 'package:google_fonts/google_fonts.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  


  try {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    await Geolocator.requestPermission();
    print("✅ all Await file successfully loaded!");

    // ✅ Print Firebase integration success in terminal
    print("✅ Firebase is integrated successfully!");
  } catch (e) {
    print("🔥 Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale){
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale('en'); //

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  //Load preferred language from Shared Preferences
  void _loadSavedLocale() async {
    final prefs  = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('preferred_language') ?? 'English';

    setState((){
      _locale = Locale(savedLanguage == 'हिन्दी' ? 'hi' : 'en');
    });
  }

  // This is called from LanguageSelectionScreen to update locale
  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(setLocale: setLocale), 
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      locale: _locale, // ✅ Use variable instead of hardcoded
    );
  }
}
/// ✅ Added missing StatefulWidget wrapper for MainScreen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}
