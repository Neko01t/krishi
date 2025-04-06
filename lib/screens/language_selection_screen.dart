import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/widgets/top_bar_getstarted_widget.dart';
import 'package:krishi/screens/get_started_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final Function(Locale)? setLocale;

  const LanguageSelectionScreen({super.key, this.setLocale});

  @override
  LanguageSelectionScreenState createState() => LanguageSelectionScreenState();
}

class LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'English';
  String searchQuery = '';

  final List<String> languages = [
    'English',
    'हिन्दी',
    'বাংলা',
    'मराठी',
    'ગુજરાતી',
    'ಕನ್ನಡ',
    'தமிழ்',
    'اردو',
    'తెలుగు',
    'മലയാളം',
    'ਪੰਜਾਬੀ',
    'ଓଡ଼ିଆ',
    'অসমীয়া',
  ];

  final List<String> subtitle = [
    'English',
    'Hindi',
    'Bengali',
    'Marathi',
    'Gujarati',
    'Kannada',
    'Tamil',
    'Urdu',
    'Telugu',
    'Malayalam',
    'Punjabi',
    'Odia',
    'Assamese',
  ];

  final Map<String, String> languageCodeMap = {
    'English': 'en',
    'हिन्दी': 'hi',
    'বাংলা': 'bn',
    'मराठी': 'mr',
    'ગુજરાતી': 'gu',
    'ಕನ್ನಡ': 'kn',
    'தமிழ்': 'ta',
    'اردو': 'ur',
    'తెలుగు': 'te',
    'മലയാളം': 'ml',
    'ਪੰਜਾਬੀ': 'pa',
    'ଓଡ଼ିଆ': 'or',
    'অসমীয়া': 'as',
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('preferred_language') ?? 'English';
    });
  }

  void updateLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferred_language', language);

    // Get the language code (like 'hi', 'en', etc.)
    String languageCode = languageCodeMap[language] ?? 'en';
    await prefs.setString('language_code', languageCode);

    setState(() {
      selectedLanguage = language;
    });

    if (widget.setLocale != null) {
      widget.setLocale!(Locale(languageCode));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 200),
        content: Text('Language updated to $language'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFDBE9B0),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBarGetStarted(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Your Language",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: languages
                    .where((lang) => subtitle[languages.indexOf(lang)]
                        .toLowerCase()
                        .contains(searchQuery))
                    .map((lang) => Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 218, 241, 147),
                            border: Border.all(
                              color: const Color.fromARGB(100, 0, 0, 0),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: const EdgeInsets.all(8.0),
                          child: RadioListTile(
                            title: Text(lang,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 19, 19, 19),
                                )),
                            subtitle: Text(subtitle[languages.indexOf(lang)],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 109, 109, 109),
                                )),
                            value: lang,
                            groupValue: selectedLanguage,
                            onChanged: (value) {
                              updateLanguage(value!);
                            },
                            activeColor: Colors.green,
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  updateLanguage(selectedLanguage);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GetStartedScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
