import 'dart:collection';
import 'package:gobang/card/base_card.dart';
import 'package:gobang/card/card_badknight.dart';
import 'package:gobang/card/card_black_bussinessman.dart';
import 'package:gobang/card/card_bussinessman.dart';
import 'package:gobang/card/card_holyknight.dart';
import 'package:gobang/card/card_soldier.dart';
import 'package:gobang/card/card_spearmen.dart';
import 'package:gobang/card/card_swordsman.dart';
import 'package:gobang/flyweight/Chess.dart';

import '../card/card_treasure.dart';

/// 棋子的享元工厂，采用单例模式
class CardFactory {
  CardFactory._();

  static CardFactory? _factory;

  static CardFactory getInstance() {
    if (_factory == null) {
      _factory = CardFactory._();
    }
    return _factory!;
  }

  HashMap<int, BaseCard> _hashMap = HashMap<int, BaseCard>();

  BaseCard getBaseCard(int type) {
    BaseCard card;
    if (_hashMap[type] != null) {
      card = _hashMap[type]!;
    } else {
      switch (type) {
        case -1:
          card = CardTreasure();
          break;
        case 0:
          card = CardSoldier();
          break;
        case 1:
          card = CardSwordsman();
          break;
        case 2:
          card = CardBadKnight();
          break;
        case 3:
          card = CardBlackBussinessman();
          break;
        case 4:
          card = CardBussinessman();
          break;
        case 5:
          card = CardHolyKnight();
          break;
        case 6:
          card = CardSpearmen();
          break;
        case 7:
          card = CardSwordsman();
          break;
        case 8:
          card = CardSwordsman();
          break;
        default:
          card = CardSoldier();
          break;
      }
      _hashMap[type] = card;
    }
    return card;
  }
}
