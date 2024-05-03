import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobang/card/card_badknight.dart';
import 'package:gobang/card/card_swordsman.dart';
import 'package:gobang/common_widget/constants/mj_colors.dart';
import 'package:gobang/common_widget/screen_sp.dart';
import 'package:sprintf/sprintf.dart';

import '../../common_widget/nav_bar.dart';
import '../card/base_card.dart';
import '../nav_service.dart';


class BuyBottomSheet extends StatefulWidget {

  final List<BaseCard> cards;

  const BuyBottomSheet(this.cards, {Key? key}) : super(key: key);

  @override
  _BuyBottomSheetState createState() => _BuyBottomSheetState();
}

class _BuyBottomSheetState extends State<BuyBottomSheet> {

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

    List<Widget> list = [];
    List<Widget> cards = widget.cards.asMap().map((i, v) => MapEntry(i, buildChildItem(i, v))).values.toList();


    for (int i = 0; i <= 1; i++) {
      list.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.csp),
        child: Container(width: MediaQuery.of(context).size.width, child: Text(sprintf("需要花费%d枚额外棋子", [i])),),
      ));
      for (int j = 0; j < 3; j++) {
        list.add(cards[i * 3 + j]);
      }
    }
    list.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.csp),
      child: Container(width: MediaQuery.of(context).size.width, child: Text("需要花费2枚额外棋子"),),
    ));
    list.add(cards[6]);
    list.add(cards[7]);
    list.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.csp),
      child: Container(width: MediaQuery.of(context).size.width, child: Text("需要花费3枚额外棋子"),),
    ));
    list.add(cards[8]);

    list.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.csp),
      child: Container(width: MediaQuery.of(context).size.width, child: Text("常驻商店"),),
    ));

    list.add(buildChildItem(9, CardSwordsman()));
    list.add(buildChildItem(10, CardBadKnight()));

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
                              children: list,
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