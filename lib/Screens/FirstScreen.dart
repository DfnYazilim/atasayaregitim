import 'package:atasayaregitim/Helper/Api.dart';
import 'package:atasayaregitim/Models/DTO/GetMyWorkPoolDTO.dart';
import 'package:flutter/material.dart';

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
    print(myPool.requestStatusId);
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
    } else {
      return Text("q");
    }
  }

  _isBaslat(GetMyWorkPoolDTO myPool) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(myPool.companyName),
            content: Text(myPool.subject),
            actions: [
              FlatButton(
                child: Text("Vazgeç"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Evet"),
                onPressed: (){
                  print('qqqqqqqqqqqqqqq');
                },
              )
            ],
          );
        });
  }
}
