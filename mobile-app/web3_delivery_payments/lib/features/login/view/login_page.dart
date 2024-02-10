import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_delivery_payments/common/blocs/bloc/wallet_bloc.dart';
import 'package:web3_delivery_payments/common/widgets/snack_bar_widget.dart';
import 'package:web3_delivery_payments/utils/constants/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  BuildContext? dialogContext;
  final String signatureFromBackend = "Web3 based delivery payment.";

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: _scaffoldKey.currentContext ?? context,
        barrierDismissible: true, //if user should not
        //cancel this dialog then set as false
        builder: (BuildContext dialogContextL) {
          dialogContext = dialogContextL;
          return BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              backgroundColor: Colors.green,
              content: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getText(state),
                  ],
                ),
              ),
            );
          });
        });
  }

  getText(WalletState state) {
    String message = "";
    if (state is WalletInitializedState) {
      //initialized metamask success
      message = state.message;
    } else if (state is WalletAuthorizedState) {
      //received authorized approval success
      message = state.message;
    } else if (state is WalletReceivedSignatureState) {
      //received signature from metamask success
      message = state.message;
    }
    return Text(
      message,
      style: const TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletErrorState) {
          Navigator.pop(context);
          ShowSnackBar.buildSnackbar(context, state.message, true);
        } else if (state is WalletReceivedSignatureState) {
          //received signature from metamask success
          Navigator.pop(context);
          ShowSnackBar.buildSnackbar(
              context, AppConstants.authenticationSuccessful);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4ade80),
                Color(0xFF3b82f6),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                const Text(
                  'Connect to an account to continue ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                GradientElevatedButton(
                  onPressed: () {
                    BlocProvider.of<WalletBloc>(context).add(
                      MetamaskAuthEvent(
                          signatureFromBackend: signatureFromBackend),
                    );
                    buildShowDialog(context);
                  },
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFc084fc),
                        Color(0xFFec4899),
                        Color(0xFFef4444),
                      ]),
                  child: const Text('Connect'),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Powered by WEB3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientElevatedButton extends StatelessWidget {
  final LinearGradient gradient;
  final Widget child;
  final VoidCallback onPressed;

  const GradientElevatedButton({
    Key? key,
    required this.gradient,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 44.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99.0),
        gradient: gradient,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99.0),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
