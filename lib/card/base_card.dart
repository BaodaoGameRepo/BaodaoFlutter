import 'package:gobang/memorandum/Checkerboard.dart' as ck;

mixin BaseCard {

    String getCardName() {
      return "";
    }

    String getCardPic() {
      return "";
    }

    List<List<int>> getCost() {
      return [];
    }

    List<List<int>> getShape() {
      return [];
    }

    get hasBuy => false;

    get count => 0;

    get playCount => 0;

    get hasCheckerboard => false;

    get hasPlay => false;

    void funBuy() {

    }

    void funCheckerboard() {

    }

    void funPlay() {

    }

    Map<int, int> getRangeMap() {
        Map<int, int> res = {};
        List<List<int>> cost = getCost();
        for (int i = 0; i < cost.length; i++) {
            for (int j = 0; j < cost[i].length; j++) {
                if (cost[i][j] == 1) {
                    res[i * i + j * j] = (res[i * i + j * j]?? 0) + 1;
                }
            }
        }
        return res;
    }

    Map<int, int> getPlayRangeMap() {
        Map<int, int> res = {};
        List<List<int>> cost = getShape();
        for (int i = 0; i < cost.length; i++) {
            for (int j = 0; j < cost[i].length; j++) {
                if (cost[i][j] == 1) {
                    res[i * i + j * j] = res[i * i + j * j]?? 0 + 1;
                }
            }
        }
        return res;
    }

    bool checkPlayTheSame(List<ck.Point> list, left, right, top, bottom) {
        if (list.length != playCount) return false;
        if (checkPlay(list, left, top) || checkPlay(list, left, bottom) ||
            checkPlay(list, right, top) || checkPlay(list, right, bottom)) {
            return true;
        }
        return false;
    }

    bool checkPlay(List<ck.Point> list, int dy, int dx) {
        Map<int, int> res = getPlayRangeMap();
        for (ck.Point p in list) {
            int dis = (p.dx - dx) * (p.dx - dx) + (p.dy - dy) * (p.dy - dy);
            if ((res[dis]?? 0) <= 0) {
                return false;
            } else {
                res[dis] = (res[dis]?? 0) - 1;
            }
        }
        return true;
    }


    bool checkTheSame(List<ck.Point> list, left, right, top, bottom) {
        if (list.length != count) return false;
        if (check(list, left, top) || check(list, left, bottom) ||
            check(list, right, top) || check(list, right, bottom)) {
            return true;
        }
        return false;
    }

    bool check(List<ck.Point> list, int dy, int dx) {
        Map<int, int> res = getRangeMap();
        for (ck.Point p in list) {
            int dis = (p.dx - dx) * (p.dx - dx) + (p.dy - dy) * (p.dy - dy);
            if ((res[dis]?? 0) <= 0) {
                return false;
            } else {
                res[dis] = (res[dis]?? 0) - 1;
            }
        }
        return true;
    }

}