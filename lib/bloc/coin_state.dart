part of 'coin_bloc.dart';

class CoinState extends Equatable {
  final int coinBalance;
  final DateTime? lastScratchTime;
  final bool isScratchable;
  final List<Map<String, dynamic>> redemptionItems;
  final List<Map<String, dynamic>> history;
  final int? lastReward;

  const CoinState({
    required this.coinBalance,
    this.lastScratchTime,
    required this.isScratchable,
    required this.redemptionItems,
    required this.history,
    this.lastReward,
  });

  factory CoinState.initial() {
    return CoinState(
      coinBalance: 1000,
      isScratchable: true,
      redemptionItems: _generateRedemptionItems(10),
      history: [],
    );
  }

  static List<Map<String, dynamic>> _generateRedemptionItems(int count) {
    final random = Random();
    return List.generate(count, (i) => {
      "id": i + 1,
      "type": random.nextBool() ? "Gift Card" : "Discount Coupon",
      "point-required": random.nextInt(996) + 5,
    });
  }

  CoinState copyWith({
    int? coinBalance,
    DateTime? lastScratchTime,
    bool? isScratchable,
    List<Map<String, dynamic>>? redemptionItems,
    List<Map<String, dynamic>>? history,
    int? lastReward,
  }) {
    return CoinState(
      coinBalance: coinBalance ?? this.coinBalance,
      lastScratchTime: lastScratchTime ?? this.lastScratchTime,
      isScratchable: isScratchable ?? this.isScratchable,
      redemptionItems: redemptionItems ?? this.redemptionItems,
      history: history ?? this.history,
      lastReward: lastReward ?? this.lastReward,
    );
  }

  @override
  List<Object?> get props => [
    coinBalance,
    lastScratchTime,
    isScratchable,
    redemptionItems,
    history,
    lastReward,
  ];
}