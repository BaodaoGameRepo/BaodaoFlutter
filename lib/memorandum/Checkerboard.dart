import 'dart:math';

import 'package:gobang/api/core/update_client.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/Position.dart';
import 'package:gobang/memorandum/game_bean.dart';
import 'package:sprintf/sprintf.dart';

import '../api/core/app_client.dart';
import '../card/base_card.dart';
import 'UserReal.dart';
import 'get_game_request.dart';

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
  discount,
  fun_check_board,
  fun_play,
  undeploy,
  card_remove,
}

class Step {
  final StepState state;
  BaseCard baseCard;
  int disCount;
  List<int> points = [];
  Step(this.state, this.baseCard, {this.disCount = 0});
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

class Buildings {
  List<Point> points = [];
  SQState type = SQState.mine;
  bool surround = false;
  List<int> belongs = [0, 0, 0, 0];
  //村庄编号
  int number = 0;
  Buildings(this.points, this.type, {this.number = 0});
}

class Disturb {
  int type = 0;
  int number = 0;
  // 0表示包围城市第一名， 1表示包围村庄第一名， 2表示移除
  String user = "";
  Disturb(this.type, this.user, this.number);
}



class Checkerboard {
  GameStep _gameStep = GameStep.deploy;
  List<int> store = [];
  List<int> legendStore = [];
  List<int> deck = [];
  List<int> discard = [];
  List<Buildings> builds = [];
  List<Step> taskStack = [];
  List<int> play = [];
  List<UserReal> userList = [];
  int _currentUser = 0;
  Checkerboard() {
    UserReal user = UserReal(0, initDecks(), initDis(), initHands(), 0, 0, 0, "1mmm", SQState.red);
    userList.add(user);
    user = UserReal(1, initDecks(), initDis(), initHands(), 0, 0, 0, "2kkk", SQState.yellow);
    userList.add(user);
    user = UserReal(2, initDecks(), initDis(), initHands(), 0, 0, 0, "3ccc", SQState.blue);
    userList.add(user);
    user = UserReal(3, initDecks(), initDis(), initHands(), 0, 0, 0, "4bbb", SQState.green);
    userList.add(user);
    store = initStore();
    deck = initStore();
    _currentUser = 0;
    stateMessage = sprintf("%s的回合！", [userList[_currentUser].id]);
    for (int i = 0; i < 16; i++) {
      _state.add(List.filled(16, SQState.empty));
    }
    loadMap1();
    initReq();
  }

  void uploadGame() {

  }

  void initReq() async {
    var res = await updateClient.request<GameBean>(GetGameRequest("2"));
    GameBean? resp = res.data;
    deck = resp?.deck?? [];
    store = resp?.normal?? [];
    legendStore = resp?.legend?? [];
    userList = [];
    for (User u in resp?.user?? []) {
      userList.add(UserReal(u.order, u.deck, u.discard, u.hands, u.gold, u.point, u.prosperity, u.id, getColor(u.color)));
    }
    play = resp?.play?? [];
    builds = [];
    for (Building b in resp?.building?? []) {
      List<Point> points = b.points.map((e) {
        int x = e ~/ 16;
        int y = e % 16;
        return Point(x, y, SQState.empty);
      }).toList();
      if (b.type == "vil") {
        var build = Buildings(points, SQState.vil, number: b.number?? 0);
        build.belongs = b.belongs;
        builds.add(build);
      } else if (b.type == "town") {
        var build = Buildings(points, SQState.town);
        build.belongs = b.belongs;
        builds.add(build);
      } else {
        var build = Buildings(points, SQState.mine);
        builds.add(build);
      }
    }
    _currentUser = resp?.current?? 0;
    String map = resp?.game?? "";
    stateMessage = sprintf("%s的回合！", [chooseUser(_currentUser).id]);
    _state = [];
    for (int i = 0; i < 16; i++) {
      List<SQState> l = [];
      for (int j = 0; j < 15; j++) {
        l.add(getColor(map.substring(i * 16 + j, i * 16 + j + 1)));
      }
      if (i < 15) {
        l.add(getColor(map.substring(i * 16 + 15, i * 16 + 15 + 1)));
      } else {
        l.add(getColor(map.substring(i * 16 + 15)));
      }
      _state.add(l);
    }
  }

  SQState getColor(String s) {
    switch (s) {
      case "r":
        return SQState.red;
      case "y":
        return SQState.yellow;
      case "b":
        return SQState.blue;
      case "g":
        return SQState.green;
      case "0":
        return SQState.empty;
      case "m":
        return SQState.mine;
      case "t":
        return SQState.town;
      case "v":
        return SQState.vil;
    }
    return SQState.red;
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

  UserReal chooseUser(int value) {
    return userList.firstWhere((e) => e.turnOrder == value);
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

  void discardStore() {
    discard.add(store[0]);
    store.removeAt(0);
    fillStore();
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
    builds.add(Buildings([Point(0, 3, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(3, 0, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(15, 3, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(3, 15, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(12, 0, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(0, 12, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(15, 12, SQState.mine)], SQState.mine));
    builds.add(Buildings([Point(12, 15, SQState.mine)], SQState.mine));
    _state[7][7] = SQState.town;
    _state[7][8] = SQState.town;
    _state[8][7] = SQState.town;
    _state[8][8] = SQState.town;
    builds.add(Buildings([Point(7, 7, SQState.town), Point(7, 8, SQState.town),
      Point(8, 7, SQState.town), Point(8, 8, SQState.town)], SQState.town));
    _state[3][7] = SQState.vil;
    _state[3][8] = SQState.vil;
    _state[8][3] = SQState.vil;
    _state[7][3] = SQState.vil;
    _state[12][7] = SQState.vil;
    _state[12][8] = SQState.vil;
    _state[8][12] = SQState.vil;
    _state[7][12] = SQState.vil;
    builds.add(Buildings([Point(3, 7, SQState.vil), Point(3, 8, SQState.vil)], SQState.vil, number: 1));
    builds.add(Buildings([Point(8, 3, SQState.vil), Point(7, 3, SQState.vil)], SQState.vil, number: 2));
    builds.add(Buildings([Point(12, 7, SQState.vil), Point(12, 8, SQState.vil)], SQState.vil, number: 3));
    builds.add(Buildings([Point(8, 12, SQState.vil), Point(7, 12, SQState.vil)], SQState.vil, number: 4));
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
    appendTask(Step(StepState.buy, card, disCount: discount));
    stateMessage = sprintf("请点击合适的位置支付%s", [card.getCardName()]);
    nextStep();
  }

  bool contain(List<int> src, List<int> tar) {
    for (int i in src) {
      if (!tar.contains(i)) {
        return false;
      }
    }
    return true;
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

  //结算建筑上方移除，和移除别人
  int removePoints(List<Point> list) {
    int num = 0;
    for (Point p in list) {
      if (p.state == SQState.mine || p.state == SQState.town || p.state == SQState.vil) {
        list.remove(p);
      } else if (p.state != SQState.empty && p.state != currentUser().color) {
        num++;
      }
    }
    return num;
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


  void checkAllSurround(int size) {
    List<Disturb> event = [];
    Map<int, bool> check = {};
    List<int> nums = [0, 0, 0, 0];
    for (Buildings building in builds) {
      check = {};
      nums = [0, 0, 0, 0];
      if (building.type == SQState.mine) {
        // if (checkMineSurroundBySomeone(building, size, currentUser().color)) {
        //   currentUser().gainGold(1);
        // }
      } else if (checkSurround(building, size)) {
        for (Point p in building.points) {
          for (int i = -1; i < 2; i++)
            for (int j = -1; j < 2; j++) {
              if ((p.dx + i >= 0) && (p.dx + i < size) && (p.dy + j >= 0) && (p.dy + j < size)) {
                int num = (p.dx + i) * size + p.dy + j;
                if (check[num] != true) {
                  switch (state[p.dx + i][p.dy + j]) {
                    case SQState.red:
                      nums[0]++;
                      break;
                    case SQState.yellow:
                      nums[1]++;
                      break;
                    case SQState.blue:
                      nums[2]++;
                      break;
                    case SQState.green:
                      nums[3]++;
                      break;
                    default:
                      break;
                  }
                  check[num] = true;
                }
              }
            }
        }
        List<int> maxseq = [];
        for (int i = 0; i < userList.length; i++) {
          if (maxseq.isEmpty) {
            maxseq.add(nums[i] + (building.belongs[i]));
          } else {
            bool b = false;
            for (int j = 0; j < maxseq.length; j++) {
              if (nums[i] + (building.belongs[i]) > maxseq[j]) {
                maxseq.insert(j, nums[i] + building.belongs[i]);
                b = true;
                break;
              }
            }
            if (!b) {
              maxseq.add(nums[i] + building.belongs[i]);
            }
          }
          var user = chooseUser(i);
          user.gainPoint(nums[i]);
          user.gainProsperity(nums[i] ~/ 3);
        }
        //颁发排名奖励
        for (int i = 0; i < userList.length; i++) {
          if (nums[i] == 0) {
            continue;
          }
          for (int j = 0; j < maxseq.length; j++) {
            print(sprintf("玩家%d 分数 %d 颁奖第%d名，要求%d, ",[i, nums[i], j, maxseq[j]]));
            if (nums[i] + building.belongs[i] >= maxseq[j]) {
              if (j + 1 < maxseq.length && maxseq[j] == maxseq[j + 1]) {
                give(i, j + 1, building.type, event);
              } else {
                give(i, j, building.type, event);
              }
              break;
            }
          }
        }
      }
    }
  }

  void give(int userOrder, int order, SQState s, List<Disturb> event) {
    var usr = chooseUser(userOrder);
    if (s == SQState.town) {
      if (order == 0) {
        usr.gainProsperity(2);
      } else if (order == 1) {
        usr.gainProsperity(1);
      } else if (order == 2) {
        usr.gainGold(3);
      }

    } else if (s == SQState.vil) {
      if (order == 0) {
        usr.gainProsperity(1);
      } else if (order == 1) {
        usr.gainGold(3);
        usr.gainPoint(1);
      } else if (order == 2) {
        usr.gainGold(2);
      }
    }
  }

  bool checkSurround(Buildings building, int size) {
    for (Point p in building.points) {
      for (int i = -1; i < 2; i++)
        for (int j = -1; j < 2; j++) {
          if ((p.dx + i >= 0) && (p.dx + i < size) && (p.dy + j >= 0) && (p.dy + j < size)) {
            if (state[p.dx + i][p.dy + j] == SQState.empty) {
              return false;
            }
          }
        }
    }
    return true;
  }

  bool checkMineSurroundBySomeone(Buildings building, int size, SQState s) {
    for (Point p in building.points) {
      for (int i = -1; i < 2; i++)
        for (int j = -1; j < 2; j++) {
          if ((p.dx + i >= 0) && (p.dx + i < size) && (p.dy + j >= 0) && (p.dy + j < size)) {
            if (!(state[p.dx + i][p.dy + j] == s ||
                state[p.dx + i][p.dy + j] == SQState.town ||
                state[p.dx + i][p.dy + j] == SQState.mine ||
                state[p.dx + i][p.dy + j] == SQState.vil)) {
              return false;
            }
          }
        }
    }
    return true;
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
      s.baseCard.funPlay(this);
      taskStack.removeLast();
      nextStep();
    }
    if (s.state == StepState.deploy) {
      stateMessage = "请点击合适的部署位置";
    }
    if (s.state == StepState.undeploy) {
      stateMessage = "请选择需要移除的棋子";
    }
    if (s.state == StepState.end_buy) {
      if (s.baseCard.cardId > 100) {
        legendStore.remove(s.baseCard.cardId);
      } else {
        store.remove(s.baseCard.cardId);
        fillStore();
      }
      currentUser().discard.add(s.baseCard.cardId);
      taskStack.removeLast();
      nextTurn();
    }
    if (s.state == StepState.end_deploy) {
      taskStack.removeLast();
      checkAllSurround(16);
      nextStep();
    }
  }

  void fillStore() {
    while (store.length < 9) {
      if (deck.isEmpty) {
        deck.addAll(discard);
        discard = [];
      }
      int p = deck.first;
      if (p > 100) {
        legendStore.add(p);
      } else {
        store.add(p);
      }
      deck.remove(p);
    }
  }


  clean(){
    _state = [];
  }

}