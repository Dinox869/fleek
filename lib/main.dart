import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fleek/home.dart';
import 'app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future main() async
{
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('sw', 'KE'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: MyHomepage (),
    );
  }
}

class MyHomepage extends StatefulWidget {
  @override
  _MyHomepage createState() => _MyHomepage();
}

class _MyHomepage extends State<MyHomepage> {
  @override
  Widget build(BuildContext context) {
    return home();
  }


}