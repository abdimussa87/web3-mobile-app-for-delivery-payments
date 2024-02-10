part of 'wallet_bloc.dart';

@immutable
abstract class WalletEvent extends Equatable {}

class MetamaskAuthEvent extends WalletEvent {
  final String signatureFromBackend;
  MetamaskAuthEvent({required this.signatureFromBackend});
  @override
  List<Object?> get props => [signatureFromBackend];
}
