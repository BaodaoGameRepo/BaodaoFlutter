import 'package:flutter/material.dart';
import 'package:gobang/common_widget/screen_sp.dart';

import '../common_widget/base_scaffold.dart';
import '../common_widget/constants/mj_colors.dart';
import 'model/app_entry_item.dart';

class AppEntryPage extends StatefulWidget {
  const AppEntryPage({super.key});

  @override
  State<AppEntryPage> createState() => _AppEntryPageState();
}

class _AppEntryPageState extends State<AppEntryPage> {
  int selectedIndex = 0;
  List<AppEntryItem> items = [];
  late PageController pageController;
  bool exitApp = false;

  @override
  void initState() {
    super.initState();
    _initTabItems();
    pageController = PageController(initialPage: selectedIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      builder: ((context) {
        return Column(
          children: [
            Expanded(child: _pagesWidget()),
          ],
        );
      }),
      extendBody: true,
      disableEdit: true,
      bottomBar: _bottomNavBar(),
    );
  }

  void _initTabItems() {
    items.addAll([
      AppEntryItem.home(),
      AppEntryItem.chat(),
    ]);
  }

  Widget _pagesWidget() {
    return PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return items[index].child;
        },
        controller: pageController,
        onPageChanged: (index) {
          _changeIndex(index);
        },
        itemCount: items.length);
  }

  Widget _bottomNavBar() {
    return Container(
      // height: 88,
      decoration: const BoxDecoration(
          color: MJColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      child: Stack(children: [
        Positioned(
          top: 3.csp,
          // left: 22.csp,
          left: MediaQuery.of(context).size.width / 2 * selectedIndex +
              MediaQuery.of(context).size.width / 4 -
              44.csp,
          child: Container(
            width: 88.csp,
            height: 50.csp,
            decoration: BoxDecoration(
              color: MJColors.defaultGreen,
              borderRadius: BorderRadius.circular(12.csp),
            ),
          ),
        ),
        BottomNavigationBar(
          selectedFontSize: 11.csp,
          unselectedFontSize: 11.csp,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: MJColors.white,
          elevation: 0,
          backgroundColor: MJColors.transparent,
          unselectedItemColor: Color(0xFF8CCAFF),
          currentIndex: selectedIndex,
          onTap: (index) {
            _changeIndex(index);
          },
          items: items.map((i) {
            return BottomNavigationBarItem(
                icon: Image.asset(i.iconName, width: 24.csp, height: 24.csp),
                activeIcon: Image.asset(i.activeIconName,
                    width: 24.csp, height: 24.csp),
                label: i.label,
                backgroundColor: MJColors.white);
          }).toList(),
        ),
      ]),
    );
  }

  void _changeIndex(int index) {
    if (index == selectedIndex) {
      return;
    }
    if (!mounted) return;
    setState(() {
      selectedIndex = index;
      pageController.jumpToPage(selectedIndex);
    });
  }
}
