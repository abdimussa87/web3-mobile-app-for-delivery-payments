import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3_delivery_payments/common/repositories/wallet_connector_repository.dart';
import 'package:web3_delivery_payments/utils/constants/app_constants.dart';
import 'package:web3_delivery_payments/utils/helpers/log_helper.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletConnectorRepository _walletConnectorService;
  WalletBloc({WalletConnectorRepository? walletConnectorRepository})
      : _walletConnectorService =
            walletConnectorRepository ?? WalletConnectorRepository(),
        super(WalletInitialState()) {
    //now send that signature to the metamask, but before this initialize metamask and approve sign-in request
    on<MetamaskAuthEvent>((event, emit) async {
      emit(WalletInitializedState(message: AppConstants.initializing));
      bool isInitialize = await _walletConnectorService.initialize();
      if (isInitialize) {
        emit(WalletInitializedState(message: AppConstants.initialized));
        ConnectResponse? resp = await _walletConnectorService
            .connect(); //first connect with metamask

        if (resp != null) {
          //get metamask uri from resp
          Uri? uri = resp.uri;
          if (uri != null) {
            //send metamask request for authorization, before this launch url for redirecting to metamask app
            bool canLaunch = await _walletConnectorService.onDisplayUri(uri);
            if (!canLaunch) {
              emit(
                  WalletErrorState(message: AppConstants.metamaskNotInstalled));
            } else {
              SessionData?
                  sessionData = //send  signature to metamask to get authorize
                  await _walletConnectorService.authorize(
                      resp, event.signatureFromBackend);
              if (sessionData != null) {
                emit(WalletAuthorizedState(
                    message: AppConstants.connectionSuccessful));
                if (resp.session.isCompleted) {
                  final String walletAddress = NamespaceUtils.getAccount(
                    sessionData.namespaces.values.first.accounts.first,
                  );
                  logPrint("WALLET ADDRESS - $walletAddress");
                  //now again go to app ans check for message sign in request
                  bool canLaunch =
                      await _walletConnectorService.onDisplayUri(uri);
                  if (!canLaunch) {
                    emit(WalletErrorState(
                        message: AppConstants.metamaskNotInstalled));
                  } else {
                    //now send signature to metamask to get signed
                    final signatureFromWallet =
                        await _walletConnectorService.sendMessageForSigned(
                            resp,
                            walletAddress,
                            sessionData.topic,
                            event.signatureFromBackend);
                    if (signatureFromWallet != null &&
                        signatureFromWallet != "") {
                      emit(WalletReceivedSignatureState(
                          signatureFromWallet: signatureFromWallet,
                          signatureFromBk: event.signatureFromBackend,
                          walletAddress: walletAddress,
                          message: AppConstants.authenticatingPleaseWait));
                    } else {
                      //user denied signature request
                      emit(WalletErrorState(
                          message: AppConstants.userDeniedMessageSignature));
                    }
                    //now disconnect wallet
                    _walletConnectorService.disconnectWallet(
                        topic: sessionData.topic);
                  }
                }
              } else {
                //user cancel the connection request with metamask
                emit(WalletErrorState(
                    message: AppConstants.userDeniedConnectionRequest));
              }
            }
          }
        }
      } else {
        emit(WalletErrorState(message: AppConstants.walletConnectError));
      }
    });
  }
}
