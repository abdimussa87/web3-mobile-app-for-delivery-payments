import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:web3_delivery_payments/common/models/chain_metadata_model.dart';
import 'package:web3_delivery_payments/utils/helpers/log_helper.dart';
import 'package:web3_delivery_payments/utils/constants/wallet_constants.dart';
import 'package:web3_delivery_payments/utils/helpers/url_helper.dart';

class WalletConnectorRepository {
  late SignClient _wcClient;
  final ChainMetadata _chainMetadata = WalletConstants.mainChainMetaData;

  SignClient get wClient => _wcClient;

  Future<bool> initialize() async {
    bool isInitialize = false;
    try {
      _wcClient = await SignClient.createInstance(
        relayUrl: _chainMetadata.relayUrl,
        projectId: _chainMetadata.projectId,
        metadata: PairingMetadata(
            name: "MetaMask",
            description: "MetaMask login",
            url: _chainMetadata.walletConnectUrl,
            redirect: Redirect(universal: _chainMetadata.redirectUrl),
            icons: []),
      );
      isInitialize = true;
    } catch (err) {
      logPrint("Catch wallet initialize error $err");
    }
    return isInitialize;
  }

  Future<ConnectResponse?> connect() async {
    try {
      ConnectResponse? resp = await wClient.connect(requiredNamespaces: {
        _chainMetadata.type: RequiredNamespace(
          chains: [_chainMetadata.chainId], // Ethereum chain
          methods: [_chainMetadata.method], // Requestable Methods
          events: _chainMetadata.events, // Requestable Events
        )
      });

      return resp;
    } catch (err) {
      logPrint("Catch wallet connect error $err");
    }
    return null;
  }

  Future<SessionData?> authorize(
      ConnectResponse resp, String unSignedMessage) async {
    SessionData? sessionData;
    try {
      sessionData = await resp.session.future;
    } catch (err) {
      logPrint("Catch wallet authorize error $err");
    }
    return sessionData;
  }

  Future<String?> sendMessageForSigned(ConnectResponse resp,
      String walletAddress, String topic, String unSignedMessage) async {
    String? signature;
    try {
      Uri? uri = resp.uri;
      if (uri != null) {
        // Now that you have a session, you can request signatures
        final res = await wClient.request(
          topic: topic,
          chainId: _chainMetadata.chainId,
          request: SessionRequestParams(
            method: _chainMetadata.method,
            params: [unSignedMessage, walletAddress],
          ),
        );
        signature = res.toString();
      }
    } catch (err) {
      logPrint("Catch SendMessageForSigned error $err");
    }
    return signature;
  }

  Future<bool> onDisplayUri(Uri? uri) async {
    final link =
        formatNativeUrl(WalletConstants.deepLinkMetamask, uri.toString());
    var url = link.toString();
    if (!await canLaunchUrlString(url)) {
      return false;
    }
    return await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  Future<void> disconnectWallet({required String topic}) async {
    await wClient.disconnect(
        topic: topic, reason: Errors.getSdkError(Errors.USER_DISCONNECTED));
  }
}
