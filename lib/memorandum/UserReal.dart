import 'package:gobang/card/base_card.dart';
import 'package:gobang/memorandum/Checkerboard.dart';

class User extends Object {

  List<BaseCard> deck;

  List<BaseCard> discard;

  List<BaseCard> hands;

  int gold = 0;

  int point = 0;

  int prosperity = 0;

  String id = "";

  SQState color = SQState.empty;

  User(this.deck,this.discard,this.hands,this.gold,this.point,this.prosperity,this.id,this.color,);

}