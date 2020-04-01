import 'package:flutter/material.dart';
import 'package:lojavirtual/acreens/home_screen.dart';
import 'package:lojavirtual/model/cart_model.dart';
import 'package:lojavirtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        // ScopedModel<UserModel>  = esttamos dizendo que toda o nosso app poderá aer modificado por essa class
        // UserModel
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'Flutter loja',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141)),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        }));
  }
}

/* 
ATENÇÃO: Tive que fazer uma modificação extra no arquivo "project/app/build.gradle"

android {
    defaultConfig {
        ...
        multiDexEnabled true
    }
    ...
}

dependencies {
  compile 'com.android.support:multidex:1.0.3'
}

sege link :
https://stackoverflow.com/questions/55591958/flutter-firestore-causing-d8-cannot-fit-requested-classes-in-a-single-dex-file/55592039

emulador sem espaço:
https://stackoverflow.com/questions/57000915/error-adb-exited-with-exit-code-1-performing-streamed-install
*/
