import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/Position.dart';
import 'package:sprintf/sprintf.dart';

import '../card/base_card.dart';

enum SQState {
  red,

  blue,

  green,

  yellow,

  mine,

  vil,

  town,

  empty
}

enum Step {
  deploy,
  buy,
  undeploy,
  empty
}

class Point {
  int dx = 0;
  int dy = 0;
  SQState state = SQState.empty;

  Point(this.dx, this.dy, this.state);
}



class Checkerboard {

  Checkerboard() {
    stateMessage = "你的回合！";
    for (int i = 0; i < 16; i++) {
      _state.add(List.filled(16, SQState.empty));
    }
    loadMap1();
  }

  void loadMap1() {
    _state[0][3] = SQState.mine;
    _state[3][0] = SQState.mine;
    _state[12][0] = SQState.mine;
    _state[15][3] = SQState.mine;
    _state[0][12] = SQState.mine;
    _state[3][15] = SQState.mine;
    _state[12][15] = SQState.mine;
    _state[15][12] = SQState.mine;
    _state[7][7] = SQState.town;
    _state[7][8] = SQState.town;
    _state[8][7] = SQState.town;
    _state[8][8] = SQState.town;
    _state[3][7] = SQState.vil;
    _state[3][8] = SQState.vil;
    _state[8][3] = SQState.vil;
    _state[7][3] = SQState.vil;
    _state[12][7] = SQState.vil;
    _state[12][8] = SQState.vil;
    _state[8][12] = SQState.vil;
    _state[7][12] = SQState.vil;
  }

  Step _step = Step.empty;

  String stateMessage = "";

  Step get step{
    return _step;
  }

  BaseCard? currentPlay;

  List<List<SQState>> _state = [];

  List<List<SQState>> get state{
    return _state;
  }


  void updata(List<Point> points) {
    for (Point point in points) {
      _state[point.dx][point.dy] = point.state;
    }
  }

  void buy(BaseCard card, {discount = 0}) {

  }

  void deploy(BaseCard card) {
    _step = Step.deploy;
    currentPlay = card;
    stateMessage = sprintf("请点击合适的位置摆放%s", [card.getCardName()]);
  }

  void stepOver() {
    if (_step == Step.deploy) {
      stateMessage = "已部署";
      _step = Step.empty;
    }
  }


  clean(){
    _state = [];
  }



}