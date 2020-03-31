import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/signup_screen.dart';
import 'package:lojavirtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emialController = TextEditingController();
  final _passController = TextEditingController();

  // A chave a seguir eu vou usar na validaçaõ do Form
  final _formKey = GlobalKey<FormState>();

  final _scaffodKey = GlobalKey<
      ScaffoldState>(); // essa key é para que eu tenha acesso ao scaffod fora do método sobreescito loga abaixo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffodKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              // pushAndRemoveUntil = vai substituir a tela anterios pela nova tela sem a opção de voltar
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SingUpScreen()));
            },
            child: Text(
              "Criar Conta",
              style: TextStyle(fontSize: 15),
            ),
            textColor: Colors.white,
          )
        ],
      ),
      // Form = é muito útil na questão de validações
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          // se nosso modelo estiver carregando, retorne aquele negócio lá que fica rodando
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Form(
            key:
                _formKey, // para que eu possa ter acesso a chave de dentro do controler
            child: ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                TextFormField(
                  controller: _emialController,
                  decoration: InputDecoration(
                      hintText:
                          "E-mail"), // é tipo a sombra que fica no campo de textxo
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@gmail.com"))
                      return "E-mail inválido!";
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText:
                          "Senha"), // é tipo a sombra que fica no campo de textxo
                  validator: (text) {
                    if (text.isEmpty || text.length < 6)
                      return "Senha Inválida!";
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      if (_emialController.text.isEmpty) {
                        _scaffodKey.currentState.showSnackBar(SnackBar(
                          content: Text("Insira seu email para recuperação !"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        model.recoverPass(_emialController.text);
                        _scaffodKey.currentState.showSnackBar(SnackBar(
                          content: Text("Confira Seu Email!"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Text(
                      "Esqueci minha Senha",
                      textAlign: TextAlign.right,
                    ),
                    padding: EdgeInsets
                        .zero, // só pra tirrar as bordas que ficam lá no botão
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  // só para deixalo umpouco mais alto
                  height: 44,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // aqui estamos pedindo para verificar se os campos estão validados de acordo com as especificações impostas

                      }
                      model.signIn(
                          email: _emialController.text,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFaild: _onFaild);
                    },
                    child: Text(
                      "Entar",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ));
      }),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFaild() {
    _scaffodKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao entar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
