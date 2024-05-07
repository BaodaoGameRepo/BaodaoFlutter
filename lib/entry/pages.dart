import 'package:gobang/welcome_page.dart';

import '../router/router_cons.dart';
import '../router/router_page_wrap.dart';
import 'app_entry.dart';

final pages = <RoutePageWrap>[
  OriginRoutePageBuilder(FlutterRouterCons.appEntry,
      builder: (context, setting) {
    return const AppEntryPage();
  }),
  OriginRoutePageBuilder(FlutterRouterCons.welcome,
      builder: (context, setting) {
        return const WelcomePage();
      }),
];
