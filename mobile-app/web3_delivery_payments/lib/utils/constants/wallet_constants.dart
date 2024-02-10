import 'package:web3_delivery_payments/common/models/chain_metadata_model.dart';

class WalletConstants {
  static const mainChainMetaData = ChainMetadata(
    type: "eip155",
    chainId: 'eip155:11155111',
    name: 'Ethereum',
    method: "personal_sign",
    events: ["chainChanged", "accountsChanged"],
    relayUrl: "wss://relay.walletconnect.com",
    projectId: "83223a887a47e6723af8d2bc0b1fe8d2",
    redirectUrl: "metamask://com.example.web3_delivery_payments",
    walletConnectUrl: "https://walletconnect.com",
  );
  static const deepLinkMetamask = "metamask://wc?uri=";
}
