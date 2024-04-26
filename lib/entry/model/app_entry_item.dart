import 'package:flutter/widgets.dart';

import '../../GamePage.dart';
import '../string_values.dart';

enum TabBusinessType { home, profile, chat }

class AppEntryItem {
  late Widget child;
  late String label;
  late TabBusinessType type;
  late bool isShowRedDot = false;
  late String iconName;
  late String activeIconName;

  AppEntryItem(
      {required this.child,
      this.label = '',
      this.type = TabBusinessType.home,
      this.isShowRedDot = false,
      this.iconName = '',
      this.activeIconName = ''});

  AppEntryItem.home() {
    label = AppEntryStringValues.tabHome;
    child = GamePage();
    type = TabBusinessType.home;
    isShowRedDot = false;
    iconName = 'images/png/icon_tabbar_home_default.png';
    activeIconName = 'images/png/icon_tabbar_home_active.png';
  }

  AppEntryItem.chat() {
    label = AppEntryStringValues.tabChat;
    child = Container();
    type = TabBusinessType.chat;
    isShowRedDot = false;
    iconName = 'images/png/icon_tabbar_chat_default.png';
    activeIconName = 'images/png/icon_tabbar_chat_active.png';
  }
}
