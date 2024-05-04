import 'package:gobang/card/base_card.dart';

class CardSpearmen with BaseCard {

  @override
  String getCardName() {
    return "长矛兵";
  }

  @override
  String getCardPic() {
    return "images/png/spearmen.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[0,0,1,0,0],[0,1,1,1,0],[1,0,1,0,1],[0,0,1,0,0],[0,0,1,0,0]];
  }

  @override
  List<List<int>> getShape() {
    return [[1,1,1],[0,1,0],[0,0,0]];
  }

  @override
  get hasCheckerboard => true;

  @override
  get count => 9;

  @override
  get playCount => 4;

  @override
  get cardId => 6;

  @override
  void funCheckerboard() {

  }
}