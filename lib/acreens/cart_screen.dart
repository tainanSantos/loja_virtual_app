import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/login_screen.dart';
import 'package:lojavirtual/model/cart_model.dart';
import 'package:lojavirtual/model/user_model.dart';
import 'package:lojavirtual/tiles/cart_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            alignment:
                Alignment.center, // alinhando o texto ao centro da appbar
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
              int p = model.products
                  .length; // aqui estamos pegando o tamanho da nossa lsta de produtos
              return Text(
                "${p ?? 0} ${p == 1 ? "Iten" : "Itens"}",
                style: TextStyle(fontSize: 17),
              );
            }),
          )
        ],
      ),

      // teremos 4 confições para apresentação de conteúdo nesta tela:  ATENÇÃO

      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          // se eu estou carregando e estou Logado
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).isLoggedIn()) {
          // se o usuário não estiver Logado
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Faça o login para adcionar o produto",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                    child: Text(
                      "Entar",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    })
              ],
            ),
          );
        } else if (model.products == null || model.products.length == 0) {
          // se a alista de produtos for nula ou se não tiver nenhum produto na lista
          return Center(
            child: Text(
              "Nenhum produto no carrino!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          //condiçaõ que quando eu tenho produtos no carrinho e também estou logado no app
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((product) {
                  return CartTite(product);
                }).toList(),
              )
            ],
          );
        }
      }),
    );
  }
}
