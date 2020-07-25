import 'package:atasayaregitim/Helper/Api.dart';
import 'package:atasayaregitim/Models/DTO/GetMyWorkPoolDTO.dart';
import 'package:atasayaregitim/Models/DTO/SendIdDTO.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<GetMyWorkPoolDTO> myPools = new List<GetMyWorkPoolDTO>();
  Api api = new Api();

  Future<void> getMyPool() async {
    final result = await api.getMyWorkPool();
    if (result != null) {
      setState(() {
        myPools = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _myPool();
  }

  @override
  void initState() {
    getMyPool();
    super.initState();
  }

  Widget _myPool() {
    return ListView.builder(
        itemCount: myPools.length,
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(myPools[i].companyName),
            subtitle: Text(myPools[i].subject),
            trailing: _trailinOlustur(myPools[i]),
            leading: _iconOlustur(myPools[i]),
          );
        });
  }

  _iconOlustur(GetMyWorkPoolDTO myPool) {
    if (myPool.requestStatusId == 8) {
      return Icon(
        Icons.refresh,
        color: Colors.green,
      );
    } else if (myPool.requestStatusId == 2) {
      return Icon(
        Icons.play_arrow,
        color: Colors.orange,
      );
    } else {
      return Icon(
        Icons.work,
        color: Colors.deepPurple,
      );
    }
  }

  _trailinOlustur(GetMyWorkPoolDTO myPool) {
    if (myPool.requestStatusId == 2) {
      return InkWell(
        onTap: () {
          _isBaslat(myPool);
        },
        child: Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
      );
    } else if (myPool.requestStatusId == 4) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Icon(
              Icons.stop,
              color: Colors.red,
            ),
          ),
          InkWell(
            child: Icon(
              Icons.pause,
              color: Colors.orange,
            ),
            onTap: () {
              _bekletmePop(myPool);
            },
          ),
        ],
      );
    } else if (myPool.requestStatusId == 8) {
      return InkWell(
        child: Icon(Icons.play_circle_filled,color: Colors.orange,),
        onTap: (){
          _isBaslat(myPool);
        },
      );
    } else {
      return Text(myPool.requestStatusId.toString());
    }
  }

  _isBaslat(GetMyWorkPoolDTO myPool) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(myPool.companyName),
            content:
                Text(myPool.subject + " başlatmak istediğinize emin misiniz?"),
            actions: [
              FlatButton(
                child: Text("Vazgeç"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Evet"),
                onPressed: () {
                  sendProcess(myPool.requestsId);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> sendProcess(int id) async {
    SendIdDTO dto = new SendIdDTO();
    dto.id = id;
    final result = await api.requestProcess(dto);
    if (result == 200) {
      getMyPool();
    } else {
      _hataToast();
    }
  }

  _bekletmePop(GetMyWorkPoolDTO myPool) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(myPool.companyName),
            content:
            Text(myPool.subject + " durdurmak istediğinize emin misiniz?"),
            actions: [
              FlatButton(
                child: Text("Vazgeç"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Evet"),
                onPressed: () {
                  _bekletmeProcess(myPool.requestsId);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> _bekletmeProcess(int requestsId) async {
    SendIdDTO dto = new SendIdDTO();
    dto.id = requestsId;
    final result = await api.isBekletProcess(dto);
    if (result == 200) {
      getMyPool();
    } else {
      _hataToast();
    }
  }

  void _hataToast() {
    Fluttertoast.showToast(
        msg: "Hata oluştu",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
