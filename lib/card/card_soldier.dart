import 'package:gobang/card/base_card.dart';

class CardSoldier with BaseCard {

  @override
  String getCardName() {
    return "士兵";
  }

  @override
  String getCardPic() {
    return "images/png/soldier.jpg";
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
  get hasPlay => true;

  @override
  void funPlay() {

  }
}