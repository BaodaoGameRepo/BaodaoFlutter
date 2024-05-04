import 'package:gobang/card/base_card.dart';

class CardBadKnight with BaseCard {

  @override
  String getCardName() {
    return "未经训练的骑士";
  }

  @override
  String getCardPic() {
    return "images/png/bad_knight.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[1,1,0,0,0],[0,1,1,1,0],[0,1,0,1,0],[0,0,0,0,0],[0,0,0,0,0]];
  }

  @override
  List<List<int>> getShape() {
    return [[0,0,0],[0,1,0],[0,1,1]];
  }

  @override
  get hasCheckerboard => true;


  @override
  get count => 7;

  @override
  get playCount => 3;

  @override
  get cardId => 2;

  @override
  void funCheckerboard() {

  }

}