import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gobang/pages.dart';
import 'package:gobang/router/router_cons.dart';

import 'GamePage.dart';
import 'app_service.dart';
import 'common_widget/custom_toast_widget.dart';

void main() {
  CustomFlutterBinding();
  app.init();
  runApp(MyApp(FlutterRouterCons.welcome));
}

class CustomFlutterBinding extends WidgetsFlutterBinding {}

class MyApp extends StatelessWidget {

  String initRouter = "";
  MyApp(this.initRouter, {super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget application = MaterialApp(
      title: 'baodao',
      navigatorKey: app.navkey,
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: (BuildContext context, Widget? child) {
        return MediaQuery.withNoTextScaling(
            child: FlutterSmartDialog(
              child: child,
              toastBuilder: (s) {
                return CustomToastWidget(
                  msg: s,
                  alignment: Alignment.center,
                );
              },
            ));
      },
      initialRoute: initRouter,
      onGenerateRoute: buildPage,
      onUnknownRoute: buildUnknownPage,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
    );
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      child: application,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '南瓜五子棋',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: GamePage(),
    );

  }
}
