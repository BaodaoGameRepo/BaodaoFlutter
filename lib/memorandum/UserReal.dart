import 'package:gobang/card/base_card.dart';
import 'package:gobang/memorandum/Checkerboard.dart';

class UserReal extends Object {

  late List<int> deck;

  late List<int> discard;

  late List<int> hands;

  int gold = 0;

  int point = 0;

  int prosperity = 0;

  String id = "";

  SQState color = SQState.empty;

  UserReal(this.deck,this.discard,this.hands,this.gold,this.point,this.prosperity,this.id,this.color,);

}