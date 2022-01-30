import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'mainscreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State {
  String passwordUser = "";
  String loginUser = "";

 bool userControll(){
   if (passwordUser !="root"||loginUser !="root"){
     return false;
   }
   return true;
 }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/galaxy-stars.jpg"),
          fit: BoxFit.cover,
        )),
        //    color: Colors.greenAccent,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        TextField(
                          onChanged:  (text){
                            loginUser = text;
                          },
                          decoration: InputDecoration(
                            //  labelText: userName,
                              counterText: 'Логин',
                          ),
                        ),
                        // SizedBox(
                        //   height: 1,
                        // ),
                        TextField(
                          onChanged:  (text){
                            passwordUser = text;
                          },
                          decoration: InputDecoration(
                              //labelText: loginUser,
                              counterText: 'Пароль'),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.white,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  (userControll()) ? Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen())) : showAlertDialog(context) ;
                },
                child: Text('Вход'),
              ),

            ],
          ),
        ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(

      alignment: Alignment.center,
      child: Text(
        'Добро пожаловать',
        style: TextStyle(color: Colors.black, fontSize: 34),

      ),
    ),
  );
}
showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'OK'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Ошибка доступа"),
    content: const Text("Пользователя с таким логином или паролем не найдено"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}