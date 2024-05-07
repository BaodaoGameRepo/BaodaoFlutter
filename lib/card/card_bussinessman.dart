import 'package:gobang/card/base_card.dart';

import '../memorandum/Checkerboard.dart';

class CardBussinessman with BaseCard {

  @override
  String getCardName() {
    return "商人";
  }

  @override
  String getCardPic() {
    return "images/png/bussinessman.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[1,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]];
  }

  @override
  List<List<int>> getShape() {
    return [[1,0,0],[0,0,0],[0,0,0]];
  }

  @override
  get hasBuy => true;

  @override
  get hasPlay => true;

  @override
  get count => 1;

  @override
  get playCount => 1;

  @override
  get cardId => 4;

  @override
  void funBuy(Checkerboard checkerboard) {

  }

  @override
  void funPlay(Checkerboard checkerboard) {

  }
}