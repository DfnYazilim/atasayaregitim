import 'dart:convert';

import 'package:atasayaregitim/Models/DTO/LoginResultDTO.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static const String sharedSecret = ',_:W9Z=nxxM}ph=8';
  static const tokenKey = 'bakkalAmca_token_kullanici';

  static saveToken(String token) async {
    var storage = FlutterSecureStorage();
    await storage.write(key: tokenKey, value: token);
  }

  static get tokenR async {
    final storage = FlutterSecureStorage();
    String value = await storage.read(key: tokenKey);
    return value;
  }

  static Future<LoginResultDTO> readToken() async {
    print("qweqwe");
    var storage = FlutterSecureStorage();
    var value = await storage.read(key: tokenKey);
    LoginResultDTO customerLoginDTO = new LoginResultDTO();
    customerLoginDTO.token = value;
    if (customerLoginDTO.token != null) {}
    return customerLoginDTO;
  }

//
  static deleteToken() async {
    var storage = FlutterSecureStorage();
    await storage.delete(key: tokenKey);
  }

  LoginResultDTO parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    LoginResultDTO tokenDTO = new LoginResultDTO.fromJson(payloadMap);
    return tokenDTO;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
