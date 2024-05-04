import 'dart:math';

import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/Position.dart';
import 'package:sprintf/sprintf.dart';

import '../card/base_card.dart';
import 'UserReal.dart';

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
  List<int> store = [];
  List<Step> taskStack = [];
  List<int> play = [];
  List<UserReal> userList = [];
  int _currentUser = 0;
  Checkerboard() {
    UserReal user = UserReal(initDecks(), initDis(), initHands(), 0, 0, 0, "1mmm", SQState.red);
    userList.add(user);
    user = UserReal(initDecks(), initDis(), initHands(), 0, 0, 0, "2kkk", SQState.yellow);
    userList.add(user);
    user = UserReal(initDecks(), initDis(), initHands(), 0, 0, 0, "3ccc", SQState.blue);
    userList.add(user);
    user = UserReal(initDecks(), initDis(), initHands(), 0, 0, 0, "4bbb", SQState.green);
    userList.add(user);
    store = initStore();
    _currentUser = 0;
    stateMessage = sprintf("%s的回合！", [userList[_currentUser].id]);
    for (int i = 0; i < 16; i++) {
      _state.add(List.filled(16, SQState.empty));
    }
    loadMap1();
  }

  List<int> initHands() {
    List<int> hands = [];
    hands.add(0);
    hands.add(0);
    hands.add(1);
    hands.add(0);
    hands.add(6);
    return hands;
  }

  List<int> initStore() {
    List<int> store = [];
    store.add(5);
    store.add(4);
    store.add(5);
    store.add(3);
    store.add(6);
    store.add(5);
    store.add(6);
    store.add(6);
    store.add(3);
    return store;
  }

  List<int> initDis() {
    List<int> store = [];
    store.add(5);
    store.add(4);
    store.add(5);
    return store;
  }

  List<int> initDecks() {
    List<int> store = [];
    store.add(5);
    store.add(4);
    store.add(5);
    store.add(3);
    return store;
  }


  GameStep get gameStep => _gameStep;

  UserReal currentUser() {
    return userList[_currentUser];
  }
  
  set gameStep(GameStep value) {
    _gameStep = value;
  }

  void draw(int num, UserReal cu) {
    for (int i = 0; i < num; i++) {
      if (cu.deck.isEmpty) {
        cu.deck = shuffle(cu.discard);
        cu.discard = [];
      }
      if (cu.deck.isEmpty) {
        return;
      }
      cu.hands.add(cu.deck.first);
      cu.deck.removeAt(0);
    }
  }

  int getRandomInt(int min,int max) {
    final _random = new Random();
    return _random.nextInt((max - min).floor()) + min;
  }

  List<int> shuffle(List<int> arr){
    List<int> newArr = [];
    newArr.addAll(arr);
    for (var i = 1; i < newArr.length; i++){
      var j = getRandomInt(0, i);
      var t = newArr[i];
      newArr[i] = newArr[j];
      newArr[j] = t;
    }
    return newArr;
  }

  void nextTurn() {
    var cu = currentUser();
    cu.discard.addAll(play);
    play = [];
    draw(4 - cu.hands.length, cu);

    _currentUser = _currentUser + 1;
    if (_currentUser == userList.length) {
      _currentUser = 0;
    }
    stateMessage = sprintf("%s的回合！", [userList[_currentUser].id]);
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
    appendTask(Step(StepState.end_buy, card));
    appendTask(Step(StepState.buy, card));
    stateMessage = sprintf("请点击合适的位置支付%s", [card.getCardName()]);
    nextStep();
  }


  bool checkIsYours(List<Point> list, {int disCount = 0}) {
    int valid = 0;
    for (Point p in list) {
      if (_state[p.dx][p.dy] == userList[_currentUser].color) {
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
      if (_state[p.dx][p.dy] == userList[_currentUser].color) {
        return true;
      }
      if (p.dx > 0) {
        if (_state[p.dx - 1][p.dy] == userList[_currentUser].color) {
          return true;
        }
      }
      if (p.dx < 15) {
        if (_state[p.dx + 1][p.dy] == userList[_currentUser].color) {
          return true;
        }
      }
      if (p.dy > 0) {
        if (_state[p.dx][p.dy - 1] == userList[_currentUser].color) {
          return true;
        }
      }
      if (p.dy < 15) {
        if (_state[p.dx][p.dy + 1] == userList[_currentUser].color) {
          return true;
        }
      }
    }
    return false;
  }

  void deploy(BaseCard card) {
    appendTask(Step(StepState.end_deploy, card));
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
    if (s.state == StepState.end_buy) {
      taskStack.removeLast();
      nextTurn();
    }
    if (s.state == StepState.end_deploy) {
      taskStack.removeLast();
      nextStep();
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