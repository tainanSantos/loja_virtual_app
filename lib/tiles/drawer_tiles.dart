import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  // isso é para que o botão selecionado fique de uma cor diferente
  final IconData icon;
  final String text;
  final PageController controller;
  final int page; // pra eu saber de que tela que tá vindo o evento

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      // Material é para dá um efeito visual quando clicarmos em um dos itens
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          controller.jumpToPage(
              page); // estamos infromando a pagina que deverá ser aberta
        },
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 32,
                color: controller.page.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: controller.page.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
