import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/tiles/categori_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection("products")
          .getDocuments( ), // aqui estamo obtendo o sprodutos lá do firebase
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var dividerTiles =  ListTile.divideTiles(tiles: snapshot.data.documents.map((doc) {
            return CategoriTile(doc);
          }).toList(),
          color: Colors.grey[500]).toList();          
          return ListView(
              children: dividerTiles,);
        }
      },
    );
  }
}
