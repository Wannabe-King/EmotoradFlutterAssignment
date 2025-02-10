import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc() : super(CoinState.initial()) {
    on<ScratchCard>(_onScratchCard);
    on<RedeemItem>(_onRedeemItem);
    on<ResetScratchAvailability>(_onResetScratchAvailability);
  }

  void _onScratchCard(ScratchCard event, Emitter<CoinState> emit) {
    if (!state.isScratchable) return;

    final reward = 50 + Random().nextInt(451);
    final newBalance = state.coinBalance + reward;
    final now = DateTime.now();
    
    emit(state.copyWith(
      coinBalance: newBalance,
      lastScratchTime: now,
      isScratchable: false,
      lastReward: reward,
      history: List.from(state.history)
        ..add({
          'description': 'Scratch Card Reward',
          'timestamp': now,
          'points': reward,
          'transaction-type': 'credit',
        }),
    ));

    Timer(const Duration(hours: 1), () => add(ResetScratchAvailability()));
  }

  void _onRedeemItem(RedeemItem event, Emitter<CoinState> emit) {
    if (state.coinBalance < event.pointsRequired) return;

    final newBalance = state.coinBalance - event.pointsRequired;
    final now = DateTime.now();
    
    emit(state.copyWith(
      coinBalance: newBalance,
      history: List.from(state.history)
        ..add({
          'description': 'Redeemed ${event.itemType}',
          'timestamp': now,
          'points': event.pointsRequired,
          'transaction-type': 'debit',
        }),
    ));
  }

  void _onResetScratchAvailability(
    ResetScratchAvailability event,
    Emitter<CoinState> emit,
  ) {
    emit(state.copyWith(
      isScratchable: true,
      lastReward: null,
    ));
  }
}