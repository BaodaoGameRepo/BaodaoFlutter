import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobang/common_widget/screen_sp.dart';
import 'package:gobang/user_services.dart';
import 'package:rect_getter/rect_getter.dart';

import '../../app_service.dart';
import '../router/router_cons.dart';
import 'common_widget/constants/mj_colors.dart';
import 'common_widget/mj_style_text_field.dart';
import 'common_widget/nav_bar.dart';
import 'common_widget/throttle_gesture.dart';
import 'nav_service.dart';

class LoginPage extends StatefulWidget {
  final String account;

  LoginPage({Key? key, this.account = ''}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String value;

  late String pValue;

  late TextEditingController accountController;

  late TextEditingController passwordController;

  late StreamController<int> streamController;

  final globalKey = RectGetter.createGlobalKey();

  @override
  void initState() {
    if (app.isDebugMode) {
      value = '1mmm';
      pValue = '111111';
    } else {
      value = '';
      pValue = '';
    }
    accountController = TextEditingController(text: value);
    passwordController = TextEditingController(text: pValue);
    streamController = StreamController();
    streamController.add(accountController.text.length);
    accountController.addListener(() {
      streamController.add(accountController.text.length);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Container(
      height: MediaQuery.of(context).size.height - 70.csp,
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: MJColors.blackWel,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.csp),
              topRight: Radius.circular(12.csp))),
      child: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          buildNavBar(),
          const SizedBox(height: 24).csp,
          inputArea(),
        ],
      ))),
    );
  }

  Widget inputArea() {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "images/png/continue_buttons.png",
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 18).csp,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1).csp,
          child: Text("账号",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18.csp, color: MJColors.white)),
        ),
        MJStyleTextField(
          hint: "请输入账号",
          textController: accountController,
          textSize: 17,
        ),
        const SizedBox(height: 16).csp,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1).csp,
          child: Text("密码",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18.csp, color: MJColors.white)),
        ),
        MJStyleTextField(
          hint: "请输入密码",
          textController: passwordController,
          textSize: 17,
          isPassword: true,
        ),
        const SizedBox(height: 24).csp,
        buildSureButton(),
        const SizedBox(height: 24).csp,

      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24).csp,
      child: child,
    );
  }

  Widget buildSureButton() {
    return ThrottleGesture(
        callback: onSureChange,
        child: StreamBuilder<int>(
          builder: (context, snapshot) {
            if (snapshot.data == 0) {
              return Image.asset(
                "images/png/btn_login.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              );
            } else {
              return Image.asset(
                "images/png/btn_login_light.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              );
            }
          },
          stream: streamController.stream,
          initialData: 0,
        ));
  }

  void onSureChange() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (accountController.text.isEmpty) {
      app.showToast('帐号不可为空');
      return;
    }

    if (passwordController.text.isEmpty) {
      app.showToast('密码不可为空');
      return;
    }

    var resp = await userServices.smsLogin(
        accountController.text, passwordController.text);

    if (resp.success) {
      app.showToast("login success!");
      navService.routeAppEntry(
          FlutterRouterCons.appEntry
      );
    }
  }

  Widget buildNavBar() {
    return NavBar(
      backgroundColor: MJColors.blackWel,
      title: "登陆/注册",
      titleColor: MJColors.white,
      onPressed: onBackPress,
      leadIconBuilder: (context) {
        return SvgPicture.asset(
          'images/svg/icon_navbar_close.svg',
          color: MJColors.white,
          width: 18.csp,
        );
      },
      actions: const [],
    );
  }

  void onBackPress() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context);
  }
}
