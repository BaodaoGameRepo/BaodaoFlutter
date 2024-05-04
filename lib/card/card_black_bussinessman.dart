import 'package:gobang/card/base_card.dart';

class CardBlackBussinessman with BaseCard {

  @override
  String getCardName() {
    return "黑市商人";
  }

  @override
  String getCardPic() {
    return "images/png/black_bussinessman.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[1,1,1,0,0],[1,0,1,0,0],[1,1,1,0,0],[0,0,0,0,0],[0,0,0,0,0]];
  }

  @override
  List<List<int>> getShape() {
    return [[1,0,0],[1,0,0],[0,0,0]];
  }

  @override
  get hasCheckerboard => true;

  @override
  get hasPlay => true;

  @override
  get count => 8;

  @override
  get playCount => 2;

  @override
  get cardId => 3;

  @override
  void funCheckerboard() {

  }

  @override
  void funPlay() {

  }
}