import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gobang/common_widget/constants/mj_colors.dart';
import 'package:gobang/common_widget/screen_sp.dart';
import 'package:gobang/factory/ThemeFactory.dart';
import 'package:gobang/flyweight/CardFactory.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/ChessFlyweightFactory.dart';
import 'package:gobang/memorandum/Checkerboard.dart' as ck;
import 'package:gobang/state/UserContext.dart';
import 'package:gobang/utils/TipsDialog.dart';
import 'package:gobang/viewModel/GameViewModel.dart';
import 'package:sprintf/sprintf.dart';

import 'bridge/CircleShape.dart';
import 'card/base_card.dart';
import 'common_widget/buy_bottom_sheet.dart';
import 'common_widget/hand_bottom_sheet.dart';
import 'common_widget/mj_text_shadow_container.dart';
import 'factory/BlackThemeFactory.dart';
import 'factory/BlueThemeFactory.dart';
import 'flyweight/Position.dart';

var width = 0.0;

///简单的实现五子棋效果
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  ThemeFactory? _themeFactory;
  GameViewModel _viewModel = GameViewModel.getInstance();
  ck.Checkerboard _originator = ck.Checkerboard();
  Map<int, bool> check = {};
  List<int> checkList = [];
  Icon lightOn = Icon(Icons.lightbulb, color: Colors.amberAccent);
  Icon lightOff = Icon(Icons.lightbulb_outline_rounded);
  Icon circle = Icon(Icons.circle_outlined);
  Icon rect = Icon(Icons.crop_square);
  Icon? currentLight, currentShape;
  bool hasPlay = false;

  @override
  void initState() {
    currentLight = lightOn;
    _themeFactory = BlueThemeFactory();
    currentShape = circle;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _themeFactory!.getTheme().getThemeColor(),
        title: Text("报到！"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (_themeFactory is BlackThemeFactory) {
                    currentLight = lightOn;
                    _themeFactory = BlueThemeFactory();
                  } else {
                    currentLight = lightOff;
                    _themeFactory = BlackThemeFactory();
                  }
                });
              },
              icon: currentLight!),
          IconButton(
              onPressed: () {
                setState(() {
                  if (currentShape == circle) {
                    currentShape = rect;
                  } else {
                    currentShape = circle;
                  }
                });
              },
              icon: currentShape!
          ),
        ],
      ),
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
              _themeFactory!.getTheme().getThemeColor(),
              Colors.white,
            ],
                stops: [
              0.0,
              1
            ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.repeated)),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (_originator.taskStack.isNotEmpty)
                  MJTextShadowContainer(
                    width: 189.csp,
                    height: 48.csp,
                    text: "确认 >",
                    onTap: () {
                      if (checkList.isEmpty) {
                        TipsDialog.showByChoose(
                            context, "提示", "是否跳过？", "是", "否",
                                (value) {
                              if (value) {
                                _originator.taskStack.removeLast();
                                setState(() {
                                  _originator.nextStep();
                                });
                              }
                              Navigator.pop(context);
                            });
                        return;
                      }

                      if (_originator.taskStack.last.state == ck.StepState.deploy) {
                        int minX = 200,
                            minY = 200,
                            maxX = -1,
                            maxY = -1;
                        List<ck.Point> points = checkList.map((e) {
                          int x = e ~/ 16;
                          int y = e % 16;
                          if (x < minX) minX = x;
                          if (x > maxX) maxX = x;
                          if (y < minY) minY = y;
                          if (y > maxY) maxY = y;
                          return ck.Point(x, y, _originator.currentUser().color);
                        }).toList();
                        if (_originator.taskStack.last.baseCard.checkPlayTheSame(points, minY, maxY, minX, maxX) == true) {
                          if (_originator.checkNearby(points)) {
                            hasPlay = true;
                            setState(() {
                              var s = _originator.taskStack.removeLast();
                              _originator.updata(points);
                              _originator.play.add(s.baseCard.cardId);
                              _originator.currentUser().hands.remove(s.baseCard.cardId);
                            });
                          }
                        } else {
                          setState(() {
                            _originator.stateMessage = "形状不正确";
                          });
                        }
                      } else if (_originator.taskStack.last.state == ck.StepState.buy) {
                        int minX = 200,
                            minY = 200,
                            maxX = -1,
                            maxY = -1;
                        List<ck.Point> points = checkList.map((e) {
                          int x = e ~/ 16;
                          int y = e % 16;
                          if (x < minX) minX = x;
                          if (x > maxX) maxX = x;
                          if (y < minY) minY = y;
                          if (y > maxY) maxY = y;
                          return ck.Point(x, y, ck.SQState.empty);
                        }).toList();
                        if ((_originator.taskStack.last.baseCard.checkTheSame(points, minY, maxY, minX, maxX) == true)
                          && _originator.checkIsYours(points)) {
                          setState(() {
                            _originator.updata(points);
                            var task = _originator.taskStack.removeLast();
                            task.baseCard.funBuy();
                            _originator.nextStep();
                          });
                        } else {
                          setState(() {
                            _originator.stateMessage = "形状不正确";
                          });
                        }
                      } else if (_originator.taskStack.last.state == ck.StepState.fun_check_board) {
                        int minX = 200,
                            minY = 200,
                            maxX = -1,
                            maxY = -1;
                        List<ck.Point> points = checkList.map((e) {
                          int x = e ~/ 16;
                          int y = e % 16;
                          if (x < minX) minX = x;
                          if (x > maxX) maxX = x;
                          if (y < minY) minY = y;
                          if (y > maxY) maxY = y;
                          return ck.Point(x, y, ck.SQState.empty);
                        }).toList();
                        if ((_originator.taskStack.last.baseCard.checkTheSame(points, minY, maxY, minX, maxX) == true) &&
                            _originator.checkIsYours(points)) {
                            setState(() {
                              var task = _originator.taskStack.removeLast();
                              task.baseCard.funCheckerboard();
                              _originator.nextStep();
                            });
                        } else {
                          setState(() {
                            _originator.stateMessage = "形状不正确";
                          });
                        }
                      }
                    }),
                Padding(
                  padding: EdgeInsets.only(top: 14, bottom: 30),
                  child: Text(
                    _originator.stateMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                Stack(
                  children: [
                    Stack(
                      children: [
                        CustomPaint(
                          size: Size(width, width),
                          painter: CheckerBoardPainter(),
                        ),
                        CustomPaint(
                          size: Size(width, width),
                          painter: ChessPainter(turnAi, _originator),
                        )
                      ],
                    ),
                    Visibility.maintain(
                      visible: _originator.taskStack.isNotEmpty,
                        child: Container(
                          width: width,
                          height: width,
                          child: GridView.builder(
                              itemCount: 256,
                              // Generate 100 widgets that display their index in the List.
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                /// 纵轴间距
                                mainAxisSpacing: 0.0,
                                /// 横轴间距
                                crossAxisSpacing: 0.0,
                                /// 横轴元素个数
                                crossAxisCount: 16,
                                /// 宽高比
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (check[index] == true) {
                                            checkList.remove(index);
                                            check[index] = false;
                                          } else {
                                            checkList.add(index);
                                            check[index] = true;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: width / 15,
                                        height: width / 15,
                                        color: check[index] != true? MJColors.white20: MJColors.red40,
                                      ),
                                    )
                                );
                              }
                          ),
                        ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      IconButton(
                          onPressed: () async {
                              var res = await showModalBottomSheet(
                                builder: (BuildContext context) {
                                  return HandBottomSheet(_originator.currentUser().hands);
                                },
                                isScrollControlled: true,
                                enableDrag: false,
                                backgroundColor: Colors.transparent,//重要
                                context: context
                              );
                              if (res != null) {
                                if (_originator.gameStep == ck.GameStep.deploy &&
                                    _originator.taskStack.isEmpty) {
                                  playCard(res);
                                }
                              }
                          },
                          icon: Icon(Icons.book)),
                      IconButton(
                          onPressed: () async {
                            var res = await showModalBottomSheet(
                                builder: (BuildContext context) {
                                  return BuyBottomSheet(_originator.store);
                                },
                                isScrollControlled: true,
                                enableDrag: false,
                                backgroundColor: Colors.transparent,//重要
                                context: context
                            );
                            if (res != null) {
                              buyCard(res);
                            }
                          },
                          icon: Icon(Icons.monetization_on_rounded)),
                      IconButton(
                          onPressed: () {
                            if (_originator.taskStack.isNotEmpty) {
                              TipsDialog.show(context, "有操作未完成", "操作未完成，请继续操作");
                            } else if (_originator.gameStep == ck.GameStep.deploy) {
                              TipsDialog.showByChoose(
                                  context, "提示", "是否要结束部署阶段？", "是", "否",
                                      (value) {
                                    if (value) {
                                      setState(() {
                                        _originator.gameStep = ck.GameStep.buy;
                                        _originator.stateMessage = "请点击下方商店购买卡牌";
                                      });
                                    }
                                    Navigator.pop(context);
                                  });
                            } else if (_originator.gameStep == ck.GameStep.buy) {
                              TipsDialog.showByChoose(
                                  context, "提示", "是否不进行购买？", "是", "否",
                                      (value) {
                                    if (value) {
                                      setState(() {
                                        _originator.nextTurn();
                                      });
                                    }
                                    Navigator.pop(context);
                                  });
                            }
                          },
                          icon: Icon(Icons.arrow_right)),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void playCard(int cardId) {
    checkList = [];
    check = {};
    BaseCard card = CardFactory.getInstance().getBaseCard(cardId);
    _originator.deploy(card);
    setState(() {

    });
  }

  void buyCard(int cardId) {
    checkList = [];
    check = {};
    BaseCard card = CardFactory.getInstance().getBaseCard(cardId);
    setState(() {
      _originator.buy(card);
    });
  }

  /// Ai 下棋
  void turnAi() {
    if (hasPlay == true) {
      check = {};
      checkList = [];
      setState(() {
        hasPlay = false;
        _originator.nextStep();
      });
    }
  }
}

class ChessPainter extends CustomPainter {
  static int _state = 0;
  final Function _function;
  final ck.Checkerboard _originator;

  ChessPainter(Function f, this._originator) : _function = f;

  @override
  void paint(Canvas canvas, Size size) {

    double mWidth = size.width / 16;
    double mHeight = size.height / 16;
    var mPaint = Paint();



    //画子
    mPaint..style = PaintingStyle.fill;
    if (_originator.state.isNotEmpty) {
      for (int i = 0; i < _originator.state.length; i++) {
        for (int j = 0; j < _originator.state.length; j++) {
          if (_originator.state[i][j] == ck.SQState.town) {
            mPaint..color = Colors.purple;
            Rect rect = Rect.fromCircle(
                center: Offset(CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dx,
                    CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dy),
                radius: min(mWidth / 2, mHeight / 2) - 2);
            canvas.drawRect(rect, mPaint);
          } else if (_originator.state[i][j] == ck.SQState.vil) {
            mPaint..color = Colors.lightBlueAccent;
            Rect rect = Rect.fromCircle(
                center: Offset(CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dx,
                    CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dy),
                radius: min(mWidth / 2, mHeight / 2) - 2);
            canvas.drawRect(rect, mPaint);
          } else if (_originator.state[i][j] == ck.SQState.mine) {
            mPaint..color = Colors.orangeAccent;
            Rect rect = Rect.fromCircle(
                center: Offset(CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dx,
                    CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dy),
                radius: min(mWidth / 2, mHeight / 2) - 2);
            canvas.drawRect(rect, mPaint);
          } else if (_originator.state[i][j] == ck.SQState.empty) {

          } else {
            mPaint..color = getColor(_originator.state[i][j]);

            canvas.drawCircle(
                Offset(CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dx,
                    CheckerBoardPainter._crossOverBeanList[i * 16 + j]._dy),
                min(mWidth / 2, mHeight / 2) - 2,
                mPaint);
          }
        }
      }
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
        _function();
    });


  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  Color getColor(ck.SQState state) {
    if (state == ck.SQState.red) {
      return Colors.red;
    } else if (state == ck.SQState.yellow) {
      return Colors.yellow;
    } else if (state == ck.SQState.blue) {
      return Colors.blue;
    } else  {
      return Colors.green;
    }
  }
}

class CheckerBoardPainter extends CustomPainter {
  static List<CrossOverBean> _crossOverBeanList = [];
  static int _state = 0;

  @override
  void paint(Canvas canvas, Size size) {
    double mWidth = size.width / 16;
    double mHeight = size.height / 16;
    var mPaint = Paint();

    _crossOverBeanList.clear();
    //重绘下整个界面的画布背景颜色
    //设置画笔，画棋盘背景
    mPaint
      ..isAntiAlias = true //抗锯齿
      ..style = PaintingStyle.fill //填充
      ..color = Color(0x77cdb175); //背景为纸黄色
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        mPaint);
    //画棋盘网格
    mPaint
      ..style = PaintingStyle.stroke
      ..color = CupertinoColors.systemGrey6
      ..strokeWidth = 1.0;
    for (var i = 0; i <= 16; i++) {
      //画横线
      canvas.drawLine(
          Offset(0, mHeight * i), Offset(size.width, mHeight * i), mPaint);
    }
    for (var i = 0; i <= 16; i++) {
      //画竖线
      canvas.drawLine(
          Offset(mWidth * i, 0), Offset(mWidth * i, size.height), mPaint);
    }
    //记录横竖线所有的交叉点
    for (int i = 0; i <= 15; i++) {
      for (int j = 0; j <= 15; j++) {
        _crossOverBeanList.add(CrossOverBean(mWidth * j + mWidth/ 2, mHeight * i + mWidth / 2));
      }
    }
  }

  //在实际场景中正确利用此回调可以避免重绘开销，本示例我们简单的返回true
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


///记录棋盘上横竖线的交叉点
class CrossOverBean {
  double _dx;
  double _dy;

  CrossOverBean(this._dx, this._dy);
}
