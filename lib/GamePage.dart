import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gobang/bridge/ChessShape.dart';
import 'package:gobang/card/card_soldier.dart';
import 'package:gobang/card/card_spearmen.dart';
import 'package:gobang/card/card_swordsman.dart';
import 'package:gobang/common_widget/constants/mj_colors.dart';
import 'package:gobang/common_widget/screen_sp.dart';
import 'package:gobang/factory/ThemeFactory.dart';
import 'package:gobang/factory/BlueTheme.dart';
import 'package:gobang/flyweight/Chess.dart';
import 'package:gobang/flyweight/ChessFlyweightFactory.dart';
import 'package:gobang/memorandum/Checkerboard.dart' as ck;
import 'package:gobang/state/UserContext.dart';
import 'package:gobang/utils/TipsDialog.dart';
import 'package:gobang/viewModel/GameViewModel.dart';
import 'package:sprintf/sprintf.dart';

import 'bridge/CircleShape.dart';
import 'card/base_card.dart';
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

  bool hasPlay = true;


  List<BaseCard> hands = [];

  @override
  void initState() {
    currentLight = lightOn;
    _themeFactory = BlueThemeFactory();
    currentShape = circle;
    hands.add(CardSoldier());
    hands.add(CardSoldier());
    hands.add(CardSwordsman());
    hands.add(CardSoldier());
    hands.add(CardSpearmen());
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
                if (_originator.step != ck.Step.empty)
                  MJTextShadowContainer(
                    width: 189.csp,
                    height: 48.csp,
                    text: "确认 >",
                    onTap: () {
                      hasPlay = true;
                      if (_originator.step == ck.Step.deploy) {
                        int minX = 200, minY = 200, maxX = -1, maxY = -1;
                        List<ck.Point> points = checkList.map((e) {
                          int x = e ~/ 16;
                          int y = e % 16;
                          if (x < minX) minX = x;
                          if (x > maxX) maxX = x;
                          if (y < minY) minY = y;
                          if (y > maxY) maxY = y;
                          return ck.Point(x, y, ck.SQState.red);
                        }).toList();
                        if (_originator.currentPlay?.checkPlayTheSame(points, minY, maxY, minX, maxX) == true) {
                          setState(() {
                            _originator.updata(points);
                          });
                        } else {
                          setState(() {
                            _originator.stateMessage = "形状不正确";
                          });
                        }
                      }

                    },
                  ),
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
                      visible: _originator.step == ck.Step.deploy,
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
                                return HandBottomSheet(hands);
                              },
                              isScrollControlled: true,
                              enableDrag: false,
                              backgroundColor: Colors.transparent,//重要
                              context: context
                              );
                              if (res != null) {
                                playCard(res);
                              }
                          },
                          icon: Icon(Icons.book)),
                      // IconButton(
                      //     onPressed: () {
                      //       if (_viewModel.undo()) {
                      //         _originator.undo();
                      //         Ai.getInstance().init();
                      //         for (Position po in _originator.state) {
                      //           Ai.getInstance().addChessman(
                      //               po.dx ~/ (width / 15),
                      //               po.dy ~/ (width / 15),
                      //               po.chess is WhiteChess ? 1 : -1);
                      //         }
                      //         setState(() {});
                      //       } else {
                      //         TipsDialog.show(context, "提示", "现阶段不能悔棋");
                      //       }
                      //     },
                      //     icon: Icon(Icons.undo)),
                      // IconButton(
                      //     onPressed: () {
                      //       if (_viewModel.surrender()) {
                      //         TipsDialog.showByChoose(
                      //             context, "提示", "是否要投降并重新开局？", "是", "否",
                      //             (value) {
                      //           if (value) {
                      //             setState(() {
                      //               ChessPainter._position = null;
                      //               _originator.clean();
                      //               _viewModel.reset();
                      //               Ai.getInstance().init();
                      //             });
                      //           }
                      //           Navigator.pop(context);
                      //         });
                      //       } else {
                      //         TipsDialog.show(context, "提示", "现阶段不能投降");
                      //       }
                      //     },
                      //     icon: Icon(
                      //       Icons.sports_handball,
                      //       color: Colors.deepPurple,
                      //     )),
                      // IconButton(
                      //     onPressed: () {
                      //       TipsDialog.showByChoose(
                      //           context, "提示", "是否重新开局？", "是", "否",
                      //           (value) {
                      //         if (value) {
                      //           setState(() {
                      //             ChessPainter._position = null;
                      //             _originator.clean();
                      //             _viewModel.reset();
                      //             Ai.getInstance().init();
                      //           });
                      //         }
                      //         Navigator.pop(context);
                      //       });
                      //     },
                      //     icon: Icon(
                      //       Icons.restart_alt,
                      //       color: Colors.indigo,
                      //     )),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  void playCard(BaseCard card) {
    checkList = [];
    check = {};
    _originator.deploy(card);
    setState(() {

    });
  }
  /// Ai 下棋
  void turnAi() {
    if (hasPlay == true) {

      setState(() {
        _originator.stepOver();
        hasPlay = false;
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
