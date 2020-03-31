import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser; // vai ser o usuário que estara logado no sistema

  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  // método estático que vai retornar um UseModel
  // dessa froma fica bem mais fácil de ter acesso ao UserModel de uqluer Lugar do Sistema
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
    super.addListener(listener);

    _loadCurretUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFaild}) {
    isLoading = true;
    notifyListeners();

    // agor aqui em baixo vamos criar nosso usuário direto lá no firebase
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      // se deu tudo certo n acriação do usuário, ele vai cair aqui
      firebaseUser =
          user; // o usuário do firebase vai receber o novo usuário qu eue tô passando
      await _saveUserData(userData);
      onSuccess(); // voi cahamar a funação que foi um sucesso
      isLoading = false; //vou parar o carregamento
      notifyListeners(); // e notificar todos os ScopedModelDescendant
    }).catchError((error) {
      // se der algum erro ele vai cair aqui nessa parte
      onFaild();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFaild}) async {
    isLoading = true;
    notifyListeners();
    // notifyListeners(); = esse comando vai recriar tudo o que esta dentro do ScopedModelDescendant
    // isso é muito massa pra questão de login
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;
      await _loadCurretUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFaild();
      isLoading = false;
      notifyListeners();
    });
  }

  void singOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email) {
    // aqui ele já vai mandar uma mensagem para o email do usuário com os passos de configurção para que ele possa redefinir sua senha
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  // função com _ não poderão ser chamadas de fora da claas que estão
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  // funçãoq ue vai carregar o usuário assim que ele entrar no sistema
  Future<Null> _loadCurretUser() async {
    if (firebaseUser == null) {
      firebaseUser =
          await _auth.currentUser(); // pegando o uduáio direto lá no banco
    }
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
