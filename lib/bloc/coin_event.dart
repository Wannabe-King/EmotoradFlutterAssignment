part of 'coin_bloc.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();
  @override
  List<Object> get props => [];
}

class ScratchCard extends CoinEvent {}

class RedeemItem extends CoinEvent {
  final int pointsRequired;
  final String itemType;

  const RedeemItem(this.pointsRequired, this.itemType);

  @override
  List<Object> get props => [pointsRequired, itemType];
}

class ResetScratchAvailability extends CoinEvent {}