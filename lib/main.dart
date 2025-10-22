import 'package:crowdin_sdk/crowdin_sdk.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'l10n/crowdin_localizations.dart';
import 'onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Crowdin.init(
    distributionHash: '5b4dffa0c942277a54b7b8achws',
    connectionType: InternetConnectionType.any,
    updatesInterval: const Duration(minutes: 15),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: CrowdinLocalization.localizationsDelegates,
      supportedLocales: CrowdinLocalization.supportedLocales,
      locale: const Locale('en'), // or Locale('es')
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: OnboardingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  void _changeLang({required String lang}) async {
    await Crowdin.loadTranslations(Locale(lang));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppLocalizations.of(context)!.pushedButtonCount),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12,
        children: [
          FloatingActionButton(
            onPressed: () => _changeLang(lang: 'en'),
            tooltip: 'en',
            child: Text('EN'),
          ),
          FloatingActionButton(
            onPressed: () => _changeLang(lang: 'es'),
            tooltip: 'es',
            child: Text('ES'),
          ),
        ],
      ),
    );
  }
}
