import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_delivery_payments/common/blocs/bloc/wallet_bloc.dart';
import 'package:web3_delivery_payments/common/repositories/wallet_connector_repository.dart';
import 'package:web3_delivery_payments/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WalletConnectorRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WalletBloc(
                walletConnectorRepository:
                    context.read<WalletConnectorRepository>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Web3 Based Delivery Payment',
          debugShowCheckedModeBanner: false,
          routerConfig: MyRouter.router,
        ),
      ),
    );
  }
}
