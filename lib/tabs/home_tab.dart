import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBAck() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130), // cor de cima da pagina
                  Color.fromARGB(255, 253, 181, 168) // cor de baixo da pagina
                ],
                // agora vamos especificar onde cada uma das cores cores começam e terminam
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        );

    // Stack =  é utilzado quando quermos colocar uma coisa encima da outra
    return Stack(
      children: <Widget>[
        // ficou uma cor bem chique
        _buildBodyBAck(),

        // tudo o que eu for colocando aqui agora vai ficar em cima do que já tem lá
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true, // quano puxar a lista pra cima ela vai desaparecr
              backgroundColor: Colors.transparent,
              elevation:
                  0.0, // pra tirar aquela sombrina que fica do botão quando a cor é tranparent
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            // isso porque ele vai pegar uma imagem que pode demorar um poco a carregar
            // essa imagem está no futuro
            FutureBuilder<QuerySnapshot>(
              // pegado todos os documetos do firebase já ordenados pela posição
              //
              future: Firestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .getDocuments(),
              // dentro do Stack só usar componentes do tipo
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // caso eu não tenha senhum dado eu vou deixar o coisa rodando na tela
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  // caso eu tenha algum dado
                  // .count é usado pois sabemos a qunatidade de itens que serão retornados
                  return SliverStaggeredGrid.count(
                      crossAxisCount:
                          2, // quantidade máxima de blocos na orizonatal
                      mainAxisSpacing: 1.0, // espaçamento entre as imagens
                      crossAxisSpacing: 1.0, // espaço
                      staggeredTiles: snapshot.data.documents.map((doc) {
                        return StaggeredTile.count(
                            doc.data["x"], doc.data["y"]);
                      }).toList(),
                      children: snapshot.data.documents.map((doc) {
                        return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: doc.data["image"],
                          fit: BoxFit.cover, // BoxFit.cover = é para cobrir todo o espaço disponível
                        );
                      }).toList());
                }
              },
            )
          ],
        )
      ],
    );
  }
}
