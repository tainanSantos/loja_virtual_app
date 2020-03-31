import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/login_screen.dart';
import 'package:lojavirtual/model/user_model.dart';
import 'package:lojavirtual/tiles/drawer_tiles.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  // para que eu possa ter acesso ao controller do DrawerTile
  final PageController pageController;
  // esse controller eu to recebendo da rome page

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBAck() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 203, 236, 241), // cor de cima da pagina
                  Colors.white // cor de baixo da pagina
                ],
                // agora vamos especificar onde cada uma das cores cores começam e terminam
                begin: Alignment
                    .topCenter, // ele vai começar ( a cor no caso ) inteiramente na parte do topo do widget
                end: Alignment.bottomCenter),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBAck(),
          ListView(
            padding: EdgeInsets.only(left: 30, top: 15),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 0),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        // estamos posicionando o texto dentro do stack
                        top: 0,
                        left: 0,
                        child: Text(
                          "Flutter's \nClotling",
                          style: TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: ScopedModelDescendant<UserModel>(
                            // essa é a unica parte que eu quero mudar no meu drawr
                            builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]} ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                      ? "Entre ou cadastre-se ->"
                                      : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor, // aqui ele vai pegar a cor de tema que foi definida lá no início do app
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn())
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  else
                                    model.singOut();
                                },
                              )
                            ],
                          );
                        }))
                  ],
                ),
              ),
              Divider(),
              // PageController tá vindo lá da minha tela inícial
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Loja", pageController, 2),
              DrawerTile(
                  Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
