import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/cart_screen.dart';
import 'package:lojavirtual/acreens/login_screen.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/model/cart_model.dart';
import 'package:lojavirtual/model/user_model.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(
      product); // lembrar de passar  produto aqui para que eu possa ter acessoa  ele nas próximas linhas
}

class _ProductScreenState extends State<ProductScreen> {
  // outra forma de acessar o produto que foi definido lá no outro construtor

  final ProductData product;

  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primayColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              // carregando a imagem da internet
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0, // é o espaçamento entre os pontos
              dotBgColor: Colors.transparent,
              dotColor: primayColor,
              autoplay: true, // tag para animação de imagens
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // aqui vai fazer com que os componentes da coluna tentes ocupar o maior espaço possível
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines:
                      3, // o texto não vai poder ocupar mais de que 3 linhas
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: primayColor),
                  maxLines:
                      3, // o texto não vai poder ocupar mais de que 3 linhas
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis
                        .horizontal, // direção que os botões de tamanho irão ficar
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5),
                    children: product.sizes.map((s) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: s ==
                                          size // se o tamnho selecionado for o mesmo da cor definid
                                      ? primayColor
                                      : Colors.grey[500],
                                  width: 3)),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    // size!=null?() {}:null = se o tamanho do produto for selecionado eu posso abilitar o botão
                    // se ele não selecionou nada, então eu não ablito o botão
                    onPressed: size != null
                        ? () {
                            // aqui vamos add o conteúdo comprado ao carrinho
                            if (UserModel.of(context).isLoggedIn()) {
                              // se tem alguem logado no sistema
                              // adicionar ao carrinho
                              CartProduct cartProduct = CartProduct();
                              cartProduct.size = size;
                              cartProduct.quantity = 1; // sempre que eu for add alguma coisa ao carrinho ele sempre vai add 1 quantidade daquele iten
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;

                              CartModel.of(context).addCartItem(cartProduct);
                            
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              // vamos mandar o usuário logar no sistema
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho" : "Entre para Comprar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: primayColor,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
