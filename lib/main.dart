import 'package:coani/Home/WorkMain.dart';
import 'package:coani/Provider/TextShare.dart';
import 'package:coani/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future <void> _onBackgroundHandler(RemoteMessage message) async {

  if (kDebugMode) {
    print("_onBackgroundHandler() -----------------> ");
  }
  if(message.notification != null) {
    String action = "";
    if(message.data["action"] != null) {
      action = message.data["action"];
    }
    if (kDebugMode) {
      print("title=${message.notification!.title.toString()},\n"
          "body=${message.notification!.body.toString()},\n"
          "action=$action");
    }

    // LocalNotification().show(
    //     "_onBackgroundHandler():"+message.notification!.title.toString(),
    //     message.notification!.body.toString());
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShareText()),
      ],
      child: const CoaniApp(),
    ),
  );
}

class CoaniApp extends StatefulWidget {
  const CoaniApp({Key? key}) : super(key: key);
  @override
  _CoaniAppState createState() => _CoaniAppState();
}

class _CoaniAppState extends State<CoaniApp> {
  bool bLoad = false;
  //late Config m_config;

  Future <void> fetchPreferance() async {
    // m_config = Config();
    // await m_config.getPref();
    setState(() {
      bLoad = true;
    });
  }

  @override
  void initState() {
    fetchPreferance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      footerTriggerDistance: 10,
      dragSpeedRatio: 0.8,
      headerBuilder: () => const MaterialClassicHeader(),
      footerBuilder: () => const ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child:MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.1,
            ),
            child: child!,
          ),
          title: '코애니',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ko', 'KR'),
          ],

          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
                elevation: 1.0,
                titleTextStyle: TextStyle(
                    fontSize: 20, color: Colors.black,
                    fontWeight: FontWeight.normal)
            ),
            primaryColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown).copyWith(background: Colors.brown)
          ),
          home: const WorkMain()
      ),
    );
  }
}

