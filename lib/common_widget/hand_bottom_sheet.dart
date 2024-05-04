import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobang/common_widget/constants/mj_colors.dart';
import 'package:gobang/common_widget/screen_sp.dart';
import 'package:gobang/flyweight/CardFactory.dart';

import '../../common_widget/nav_bar.dart';
import '../card/base_card.dart';
import '../nav_service.dart';


class HandBottomSheet extends StatefulWidget {

  final List<int> cards;

  const HandBottomSheet(this.cards, {Key? key}) : super(key: key);

  @override
  _HandBottomSheetState createState() => _HandBottomSheetState();
}

class _HandBottomSheetState extends State<HandBottomSheet> {

  int choose = -1;

  @override
  void initState() {
    super.initState();
  }

  Widget buildNavBar() {
    return NavBar(
      title: "手牌",
      isAlert: true,
      height: 40.csp,
      backgroundColor: MJColors.white,
      titleColor: MJColors.black,
      leadIconBuilder: (context) {
        return SvgPicture.asset('images/svg/icon_navbar_close.svg', width: 18.csp, color: MJColors.black,);
      },
      onPressed: () {
        navService.closePage();
      },
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              if (choose != -1) {
                navService.closePage(widget.cards[choose]);
              }
            },
            child: Container(
              child: Text(
                  "确定",
                  style: TextStyle(
                      fontSize: 16.csp,
                      color: MJColors.orange,
                    fontWeight: FontWeight.bold,
                  )
              ),
              padding: EdgeInsets.only(right: 16.csp),
            )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 70.csp,
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.csp),
              topRight: Radius.circular(12.csp))
      ),
      child: Column(
        children: [
          buildNavBar(),
          Expanded(
              child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 11).csp,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 16.csp, bottom: 12.csp),
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              runSpacing: 7.csp,
                              spacing: 7.csp,
                              children: widget.cards.asMap().map((i, v) =>
                                  MapEntry(i, buildChildItem(i, CardFactory.getInstance().getBaseCard(v)))).values.toList(),
                            ),
                          )
                        ],
                      )
                  )
              ),
          )
        ],
      ),
    );
  }

  Widget buildChildItem(int i, BaseCard card) {
    double size = (MediaQuery.of(context).size.width - 34.csp) / 2;
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(onTap: () {
              choose = i;
              setState(() {

              });
            },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  color: i == choose? MJColors.orange: MJColors.white,
                  width: size,
                  height: size * 4 / 3,
                  padding: EdgeInsets.all(3).csp,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(card.getCardPic(), width: MediaQuery.of(context).size.width, fit: BoxFit.fill,),
                  ),
                ),
              ),
            ),
            if (i == choose)
              Positioned(
                  bottom: 4.csp,
                  right: 4.csp,
                  child: Image.asset("images/png/icon_checked.png", width: 20.csp, height: 20.csp, fit: BoxFit.fill,),
              )
          ],
        ),
        const SizedBox(height: 4).csp,
        Text(card.getCardName(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.csp, color: MJColors.black)),
      ],
    );
  }


}