import 'package:flutter/material.dart';
import 'package:amesaadm/models/user.dart';
import 'package:amesaadm/helpers/validators.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/user_manager.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
            title: const Text('Credencias'),
            centerTitle: true,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/signup');
                },
                style: TextButton.styleFrom(primary: Colors.white),
                child: const Text('Novo Usuário',
                    style: TextStyle(
                      fontSize: 11,
                    )),
              )
            ]),
        body: Center(
          child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formkey,
                child: Consumer<UserManager>(builder: (_, userManager, __) {
                  return ListView(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        enabled: !userManager.loading,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'E-mail',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email) {
                          if (!emailValid(email)) return 'E-mail inválido!';

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        enabled: !userManager.loading,
                        controller: passController,
                        decoration: const InputDecoration(
                          hintText: 'Senha',
                        ),
                        // keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        obscureText: true,
                        validator: (pass) {
                          if (pass.isEmpty || pass.length < 6)
                            return 'senha inválida!';
                          return null;
                        },
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: const Text('Esqueci minha senha'))),
                      ElevatedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formkey.currentState.validate()) {
                                  userManager.signIn(
                                      user: UserApp(
                                          email: emailController.text,
                                          password: passController.text,
                                          name: ''),
                                      onFail: (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Erro de credênciais: $e'),
                                              backgroundColor: Colors.red),
                                        );
                                        //     scaffoldkey.currentState.context.(snackbar);
                                      },
                                      onSucess: () {
                                        //fechar janela de login
                                        Navigator.of(context).pop();
                                      });
                                }
                              },
                        style: TextButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            //  minimumSize: Size(88, 36),
                            padding: EdgeInsets.symmetric(horizontal: 26.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                            )),
                        child: userManager.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : Text('Entrar', style: TextStyle(fontSize: 18)),
                      )
                    ],
                  );
                }),
              )),
        ));
  }
}
