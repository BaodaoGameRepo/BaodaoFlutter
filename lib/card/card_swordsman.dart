import 'package:gobang/card/base_card.dart';

class CardSwordsman with BaseCard {

  @override
  String getCardName() {
    return "未经训练的剑士";
  }

  @override
  String getCardPic() {
    return "images/png/swordsman.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[0,1,0,0,0],[1,1,0,0,0],[0,1,0,0,0],[0,0,0,0,0],[0,0,0,0,0]];
  }

  @override
  List<List<int>> getShape() {
    return [[1,1,0],[0,0,0],[0,0,0]];
  }

  @override
  get hasCheckerboard => true;

  @override
  get count => 4;

  @override
  get playCount => 2;

  @override
  get cardId => 1;

  @override
  void funCheckerboard() {

  }
}