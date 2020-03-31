// essa class vai armazenar um produto do carrinho
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {

  String cid;

  String category;
  String pid;
  int quantity;
  String size;

  CartProduct();

  ProductData productData; // serão os dados do produto no carrinho

  CartProduct.fromDocument(DocumentSnapshot document){
    // cada produto que recebermos nós uremos transfromalo em um carProduct

    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  // para dcionar qualquet dado no banco de dados
  // nos devemso antes trandoemalo em um mapa 
  Map<String, dynamic>  toMap(){
    return{
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      // "product": productData.toResumedMap()
    };
  }

}
