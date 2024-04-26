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

    get hasCheckerboard => false;

    get hasPlay => false;

    void funBuy() {

    }

    void funCheckerboard() {

    }

    void funPlay() {

    }
}