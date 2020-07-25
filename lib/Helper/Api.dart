import 'dart:convert';
import 'dart:io';
import 'package:atasayaregitim/Helper/Token.dart';
import 'package:atasayaregitim/Models/DTO/GetMyWorkPoolDTO.dart';
import 'package:atasayaregitim/Models/DTO/LoginDTO.dart';
import 'package:atasayaregitim/Models/DTO/LoginResultDTO.dart';
import 'package:atasayaregitim/Models/DTO/SendIdDTO.dart';
import 'package:atasayaregitim/Models/ItemTypes.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://192.168.1.248:8082/api/";
  String token;

  Future<LoginResultDTO> login(LoginDTO loginDTO) async {
    return http
        .post(baseUrl + 'auth/login',
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(loginDTO.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        LoginResultDTO c = LoginResultDTO.fromJson(jsonDecode(data.body));
        return c;
      }
      return null;
    });
  }

  Future<List<GetMyWorkPoolDTO>> getMyWorkPool() async {
    final tkn = await Token.readToken();
    if (tkn != null) {
      token = tkn.token;
    }
    return http
        .get(baseUrl + 'dashboard/getMyWorkPool?prm=3&typeId=2', headers: {
      HttpHeaders.authorizationHeader: 'Bearer ' + token,
      HttpHeaders.contentTypeHeader: 'application/json'
    }).then((value) {
      if (value.statusCode == 200) {
        print(json.decode(value.body));
        var users = new List<GetMyWorkPoolDTO>();
        Iterable list = json.decode(value.body);
        users = list.map((model) => GetMyWorkPoolDTO.fromJson(model)).toList();
        return users;
      } else {
        return null;
      }
    });
  }

  Future<int> requestProcess(SendIdDTO dto) async {
    return http
        .post(baseUrl + 'requests/requestProcess',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer ' + token,
            },
            body: json.encode(dto.id))
        .then((data) {
      return data.statusCode;
    });
  }
}
