import 'package:atasayaregitim/Helper/Api.dart';
import 'package:atasayaregitim/Helper/Token.dart';
import 'package:atasayaregitim/Models/DTO/LoginDTO.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email = 'seval.ozturk@atasayarteknoloji.com';
  var _password = '011308';
  final _formKey = GlobalKey<FormState>();

  Api api = new Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Image(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      image: CachedNetworkImageProvider(
                          "http://atasayarservis.com/assets/img/apm-mavi-1.jpg"),
                    )),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Emailiniz"),
                    onSaved: (val) {
                      setState(() {
                        _email = val;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Email hatalı';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  key: ValueKey('password'),
                  flex: 1,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Şifreniz"),
                    onSaved: (val) {
                      setState(() {
                        _password = val;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Şifre boş olamaz';
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Giriş",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _trySubmit();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _trySubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      LoginDTO loginDTO = new LoginDTO();
      loginDTO.password = _password;
      loginDTO.username = _email.trim();
      final result = await api.login(loginDTO);
      if (result != null) {
        print(result.token);
        Token.saveToken(result.token);
        _toast(true);
      } else {
        _toast(false);
      }
    } else {
      print('gümeldi');
    }
  }

  _toast(bool state) {
    if (state) {
      Fluttertoast.showToast(
          msg: "Giriş başarılı",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pushReplacementNamed(context, '/');

    } else {
      return Fluttertoast.showToast(
          msg: "Giriş bilgileri hatalıdır",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
