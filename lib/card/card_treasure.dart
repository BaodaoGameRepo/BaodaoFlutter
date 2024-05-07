import 'package:gobang/card/base_card.dart';

import '../memorandum/Checkerboard.dart';

class CardTreasure with BaseCard {

  @override
  String getCardName() {
    return "财宝";
  }

  @override
  String getCardPic() {
    return "images/png/treasure.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[1,0,0,0,1],[0,0,0,0,0],[0,0,1,0,0],[0,0,0,0,0],[1,0,1,0,1]];
  }

  @override
  List<List<int>> getShape() {
    return [[0,0,0],[0,0,0],[0,0,0]];
  }

  @override
  get hasPlay => true;

  @override
  get hasCheckerboard => true;

  @override
  get count => 6;

  @override
  get playCount => 0;

  @override
  get cardId => -1;

  @override
  void funPlay(Checkerboard checkerboard) {
    checkerboard.currentUser().gainGold(1);
  }

  @override
  void funCheckerboard(Checkerboard checkerboard) {
    checkerboard.currentUser().gainGold(2);
  }
}