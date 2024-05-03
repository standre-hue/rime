class Supply {
  int id;
  int amount;
  int prevAmount;
  int curAmount;
  DateTime createdAt;
  Supply({
    required this.id,
    required this.amount,
    required this.curAmount,
    required this.prevAmount,
    required this.createdAt,
  });
}
