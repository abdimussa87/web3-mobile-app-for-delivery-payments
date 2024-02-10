part of 'wallet_bloc.dart';

@immutable
abstract class WalletState extends Equatable {}

class WalletInitialState extends WalletState {
  @override
  List<Object?> get props => [];
}

class WalletInitializedState extends WalletState {
  final String message;
  WalletInitializedState({required this.message});
  @override
  List<Object?> get props => [message];
}

class WalletAuthorizedState extends WalletState {
  final String message;
  WalletAuthorizedState({required this.message});
  @override
  List<Object?> get props => [message];
}

class WalletReceivedSignatureState extends WalletState {
  final String message;
  final String signatureFromWallet;
  final String signatureFromBk;
  final String walletAddress;
  WalletReceivedSignatureState(
      {required this.signatureFromWallet,
      required this.signatureFromBk,
      required this.walletAddress,
      required this.message});
  @override
  List<Object?> get props =>
      [signatureFromWallet, signatureFromBk, walletAddress, message];
}

class WalletErrorState extends WalletState {
  final String message;
  WalletErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
