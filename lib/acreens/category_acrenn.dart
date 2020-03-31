import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/tiles/produst_tile.dart';

class CategoryScrenn extends StatelessWidget {
  // o documento a seguir
  // vai dizer qual é o titulo e qual é o id da categoria

  final DocumentSnapshot
      snapshot; // vai receber qual tipo de categoria que estamos navegando

  CategoryScrenn(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2, // qunatidade de tabas que vai ter na pagina
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["title"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                ),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
              // FutureBuilder é para carregar o conteúdo antes de abrur a página
              future: Firestore.instance
                  .collection("products")
                  .document(snapshot.documentID)
                  .collection("itens")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return TabBarView(
                      physics:
                          NeverScrollableScrollPhysics(), // par que ele não permita a parada de aratar a atela com o dedo
                      children: [
                        // GridView.builder =  pois podemos ter uma grade quantidade de produtos e nossa tela pode ficar um pouco muito pesada
                        // conforme a gente for rolando a tela para baixo ele vai carregando mais e mais produtos da base
                        GridView.builder(
                            padding: EdgeInsets.all(4),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    childAspectRatio: 0.65),
                            itemCount: snapshot.data.documents
                                .length, // especificando o tamanho da lista de documentos
                            itemBuilder: (context, index) {
                              // essa função vai retornar o item que sera exbido em cada posição
                              ProductData data = ProductData.fromDocuments(
                                  snapshot.data.documents[index]); // gambiarra
                              data.category = this
                                  .snapshot
                                  .documentID; // guradando a categoria a qual o produto pertence
                              return ProductTile('grid', data);
                            }),
                        ListView.builder(
                            padding: EdgeInsets.all(4),
                            itemCount: snapshot.data.documents
                                .length, // especificando o tamanho da lista de documentos
                            itemBuilder: (context, index) {
                              // essa função vai retornar o item que sera exbido em cada posição
                              ProductData data = ProductData.fromDocuments(
                                  snapshot.data.documents[index]); // gambiarra
                              data.category = this.snapshot.documentID;
                              return ProductTile('list', data);
                            }),
                      ]);
                }
              }),
        ));
  }
}
