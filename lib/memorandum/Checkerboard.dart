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

enum StepState {
  end_deploy,
  end_buy,
  deploy,
  buy,
  fun_check_board,
  fun_play,
  undeploy,
  card_remove,
}

class Step {
  final StepState state;
  BaseCard baseCard;
  Step(this.state, this.baseCard);
}


enum GameStep {
  deploy,
  buy,
}

class Point {
  int dx = 0;
  int dy = 0;
  SQState state = SQState.empty;

  Point(this.dx, this.dy, this.state);
}



class Checkerboard {
  GameStep _gameStep = GameStep.deploy;

  List<Step> taskStack = [];
  List<String> userList = [];
  List<SQState> userColor = [];
  int currentUser = 0;
  Checkerboard() {
    userList = ["1mmm", "2kkk", "3ccc", "4bbb"];
    userColor = [SQState.red, SQState.yellow, SQState.blue, SQState.green,];
    currentUser = 0;
    stateMessage = sprintf("%s的回合！", [userList[currentUser]]);
    for (int i = 0; i < 16; i++) {
      _state.add(List.filled(16, SQState.empty));
    }
    loadMap1();
  }

  GameStep get gameStep => _gameStep;

  set gameStep(GameStep value) {
    _gameStep = value;
  }

  void nextTurn() {
    currentUser = currentUser + 1;
    if (currentUser == userList.length) {
      currentUser = 0;
    }
    gameStep = GameStep.deploy;
  }

  void loadMap1() {
    _state[0][0] = SQState.yellow;
    _state[15][0] = SQState.red;
    _state[0][15] = SQState.blue;
    _state[15][15] = SQState.green;
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



  void appendTask(Step value) {
    taskStack.add(value);
  }

  String stateMessage = "";

  Step getStep() {
    return taskStack.removeLast();
  }


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
    appendTask(Step(StepState.buy, card));
    stateMessage = sprintf("请点击合适的位置支付%s", [card.getCardName()]);
  }


  bool checkIsYours(List<Point> list, {int disCount = 0}) {
    int valid = 0;
    for (Point p in list) {
      if (_state[p.dx][p.dy] == userColor[currentUser]) {
        valid++;
      }
    }
    if (valid + disCount == list.length) {
      return true;
    } else {
      return false;
    }
  }

  bool checkNearby(List<Point> list) {
    for (Point p in list) {
      if (_state[p.dx][p.dy] == userColor[currentUser]) {
        return true;
      }
      if (p.dx > 0) {
        if (_state[p.dx - 1][p.dy] == userColor[currentUser]) {
          return true;
        }
      }
      if (p.dx < 15) {
        if (_state[p.dx + 1][p.dy] == userColor[currentUser]) {
          return true;
        }
      }
      if (p.dy > 0) {
        if (_state[p.dx][p.dy - 1] == userColor[currentUser]) {
          return true;
        }
      }
      if (p.dy < 15) {
        if (_state[p.dx][p.dy + 1] == userColor[currentUser]) {
          return true;
        }
      }
    }
    return false;
  }

  void deploy(BaseCard card) {
    if (card.playCount > 0) {
      taskStack.add(Step(StepState.deploy, card));
    }
    if (card.hasPlay) {
      taskStack.add(Step(StepState.fun_play, card));
    }
    if (card.hasCheckerboard) {
      taskStack.add(Step(StepState.fun_check_board, card));
    }
    nextStep();
  }

  void nextStep() {
    if (taskStack.isEmpty) {
      return;
    }
    Step s = taskStack.last;
    if (s.state == StepState.fun_check_board) {
      stateMessage = "请点击合适的棋盘位置";
    }
    if (s.state == StepState.fun_play) {
      s.baseCard.funPlay();
      taskStack.removeLast();
      nextStep();
    }
    if (s.state == StepState.deploy) {
      stateMessage = "请点击合适的部署位置";
    }

  }
  //
  // void stepOver() {
  //   if (_step == Step.deploy) {
  //     stateMessage = "已部署";
  //     _step = Step.empty;
  //   }
  // }


  clean(){
    _state = [];
  }



}