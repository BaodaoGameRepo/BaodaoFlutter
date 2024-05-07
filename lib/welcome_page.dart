import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gobang/common_widget/screen_sp.dart';

import '../nav_service.dart';
import '../router/router_cons.dart';
import 'common_widget/base_scaffold.dart';
import 'common_widget/constants/mj_colors.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: MJColors.blackWel,
      resizeToAvoidBottomInset: true,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Image.asset(
                "images/png/background_images.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    Image.asset(
                      "images/png/logo_on_white.png",
                      width: 98.csp,
                      height: 98.csp,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 8).csp,
                    Padding(
                        padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 24)
                            .csp,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                builder: (BuildContext context) {
                                  return AnimatedPadding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    duration: Duration.zero,
                                    child: LoginPage(),
                                  );
                                },
                                enableDrag: false,
                                isDismissible: false,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent, //重要
                                context: context);
                          },
                          child: Image.asset(
                            "images/png/btn_login.png",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        )),
                    const SizedBox(height: 18).csp,
                  ],
                )),
          ],
        );
      },
      systemUiOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
