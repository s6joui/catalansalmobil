import 'package:catalansalmon_flutter/features/auth/cubit/auth_cubit.dart';
import 'package:catalansalmon_flutter/features/auth/cubit/auth_state.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/widgets/cam_logo.dart';
import 'package:catalansalmon_flutter/widgets/cam_text_field.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.communityId, this.loginResultHandler});

  final String communityId;
  final void Function(bool)? loginResultHandler;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final authRepo = context.read<AuthRepository>();
        return AuthCubit(authRepo);
      },
      child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LoginSuccessAuthState) {
                  widget.loginResultHandler?.call(true);
                }
              },
              builder: (context, state) {
                if (state is ErrorAuthState) {
                  return SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3),
                                  ),
                                  child:
                                      const Icon(Icons.priority_high, size: 40))
                              .animate()
                              .scale(),
                          const SizedBox(height: 16),
                          const Text(
                                  'Hi ha hagut un error. Comprova les teves credencials.',
                                  textAlign: TextAlign.center)
                              .animate()
                              .fadeIn(),
                          const SizedBox(height: 48),
                          SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        context.read<AuthCubit>().retryLogin();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white),
                                      child: const Text('Torna-ho a provar')))
                              .animate()
                              .fadeIn(),
                        ],
                      )));
                }
                if (state is LoadingAuthState) {
                  return const SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(child: GlobeLogo()));
                }
                if (state is LoginSuccessAuthState) {
                  return SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3),
                                  ),
                                  child: const Icon(Icons.check, size: 40))
                              .animate()
                              .scale(),
                          const SizedBox(height: 16),
                          const Text('Tot correcte!').animate().fadeIn(),
                          const SizedBox(height: 48),
                          SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white),
                                      child: const Text('Continua')))
                              .animate()
                              .fadeIn(),
                        ],
                      )));
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      const CAMLogo(),
                      const SizedBox(height: 8),
                      RichText(
                          text: TextSpan(
                              text: 'Entra amb el teu usuari i contrasenya de ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: const [
                            TextSpan(
                                text: 'catalansalmon.com',
                                style: TextStyle(fontWeight: FontWeight.w600))
                          ])),
                      const SizedBox(height: 16),
                      CAMTextField(
                          hintText: 'Usuari',
                          autofocus: true,
                          controller: _userTextController),
                      const SizedBox(height: 8),
                      CAMTextField(
                          hintText: 'Contrasenya',
                          obscureText: true,
                          controller: _passwordTextController),
                      const SizedBox(height: 16),
                      SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_userTextController.text.isEmpty) {
                                  return;
                                }
                                if (_passwordTextController.text.isEmpty) {
                                  return;
                                }
                                context.read<AuthCubit>().performLogin(
                                    _userTextController.text,
                                    _passwordTextController.text,
                                    widget.communityId);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white),
                              child: const Text('Entra'))),
                      const SizedBox(height: 16),
                      SizedBox(
                          height: 44,
                          child: MaterialButton(
                              onPressed: () {
                                final browser = ChromeSafariBrowser();
                                final uri = WebUri.uri(Uri.parse(
                                    'https://catalansalmon.com/webs/fitxa.php?tipus=1&id_ciutat=${widget.communityId}'));
                                browser.open(url: uri);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22)),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Encara no ets usuari? Registra\'t!'),
                                  SizedBox(width: 16),
                                  Icon(Icons.arrow_forward)
                                ],
                              )))
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
