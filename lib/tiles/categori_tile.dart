import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/category_acrenn.dart';

class CategoriTile extends StatelessWidget {
  // essa class vai receber os docuentos que obtivermso do banco de dados

  final DocumentSnapshot snapshot;

  CategoriTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        // abrindo a próxima tela de categorias
        // e passando o produto selecionado para ela
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CategoryScrenn(snapshot)));
      },
    );
  }
}
