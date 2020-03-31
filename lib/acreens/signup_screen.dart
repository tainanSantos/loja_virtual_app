import 'dart:async'; // isso aqui é para poder usar o Future
import 'package:flutter/material.dart';
import 'package:lojavirtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SingUpScreen extends StatefulWidget {
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _eddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffodKey = GlobalKey<
      ScaffoldState>(); // essa key é para que eu tenha acesso ao scaffod fora do método sobreescito loga abaixo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key:
            _scaffodKey, // lembrar de colocra ela aqui se não não vai funcionar
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
          actions: <Widget>[],
        ),
        // Form = é muito útil na questão de validações
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Nome Completo",
                    ),
                    validator: (text) {
                      if (text.isEmpty) return "Nome Inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@gmail.com"))
                        return "E-mail Inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha Inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _eddressController,
                    decoration: InputDecoration(
                      hintText: "Endereço",
                    ),
                    validator: (text) {
                      if (text.isEmpty) return "Endereço Inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 46,
                    child: RaisedButton(
                        child: Text(
                          "Criar Conta",
                          style: TextStyle(fontSize: 18),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "address": _eddressController.text,
                            };
                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFaild: _onFaild);
                          }
                        }),
                  )
                ],
              ));
        }));
  }

  void _onSuccess() {
    _scaffodKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    // ele espara 2 segundo para só então chamar a função de sair 
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFaild() {
    _scaffodKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar o Usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
