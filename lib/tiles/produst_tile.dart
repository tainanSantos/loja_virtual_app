import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/product_screen.dart';
import 'package:lojavirtual/datas/product_data.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      // InkWell = é a mesma coisa do gesture detector a diferença é que ele faz
      // uma pequena animação quando o usuário clicar nele
      child: InkWell(
        onTap: (){
          // aqui agora vamos abrir a a tela para ver mais detalhes obre o produto
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> ProductScreen(product))
          );
        },
        child: Card(
          child: type == 'grid'
              ? Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // as coisas estão esticadas
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text(
                            product.title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "R\$ ${product.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ))
                  ],
                )
              : Row(
                  children: <Widget>[
                    // flex = 1 é para dividir o espaço ca linha em 2 paretes iguais
                    Flexible(
                      flex: 1,
                      child: Image.network(
                        product.images[0],
                        fit: BoxFit.cover,
                        height: 258.0,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$ ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
