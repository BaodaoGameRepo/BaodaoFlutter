import 'package:gobang/card/base_card.dart';

class CardHolyKnight with BaseCard {

  @override
  String getCardName() {
    return "圣骑士";
  }

  @override
  String getCardPic() {
    return "images/png/card_holyknight.jpg";
  }

  @override
  List<List<int>> getCost() {
    return [[1,1,1,0,0],[1,1,0,0,0],[1,0,1,0,0],[0,0,0,1,0],[0,0,0,0,0]];
  }

  @override
  List<List<int>> getShape() {
    return [[1,0,0],[0,1,0],[0,0,1]];
  }

  @override
  get hasCheckerboard => true;

  @override
  get hasPlay => true;

  @override
  get count => 8;

  @override
  get playCount => 3;

  @override
  void funCheckerboard() {

  }

  @override
  void funPlay() {

  }
}