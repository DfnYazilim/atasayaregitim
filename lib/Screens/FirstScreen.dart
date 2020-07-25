import 'package:atasayaregitim/Helper/Api.dart';
import 'package:atasayaregitim/Models/DTO/GetMyWorkPoolDTO.dart';
import 'package:atasayaregitim/Models/DTO/RequestItemsDTO.dart';
import 'package:atasayaregitim/Models/DTO/SendIdDTO.dart';
import 'package:atasayaregitim/Models/ServiceTypes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<GetMyWorkPoolDTO> myPools = new List<GetMyWorkPoolDTO>();
  Api api = new Api();
  int durum = 0;
  int selectedServiceType;
  var _arizaNotu = '';
  var _ekstraNot = '';
  final _formKey = GlobalKey<FormState>();
  List<RequestItemsDTO> requestItemsDTOs = new List<RequestItemsDTO>();
  List<ServiceTypes> serviceTypes = new List<ServiceTypes>();

  Future<void> getMyPool() async {
    final result = await api.getMyWorkPool();
    if (result != null) {
      setState(() {
        myPools = result;
      });
    }
  }

  Future<void> getServiceTypes() async {
    final result = await api.getServiceTypes();
    if (result != null) {
      setState(() {
        serviceTypes = result;
      });
    }
  }

  Future<void> getRequestItems(int id) async {
    requestItemsDTOs.clear();
    final result = await api.getRequestItems(id);
    if (result != null) {
      setState(() {
        requestItemsDTOs = result;
      });
    }
  }

  _arizaNotuWidget() {
    return TextFormField(
      key: ValueKey('arizaNotu'),
      maxLines: 5,
      decoration: InputDecoration(labelText: "Arıza notu var ise giriniz"),
      onSaved: (val) {
        setState(() {
          _arizaNotu = val;
        });
      },
      validator: (value) {
        if (value.isEmpty || value.length < 5) {
          return 'Arıza notu yeterli değil';
        }
        return null;
      },
    );
  }

  _extraNotuWidget() {
    return TextFormField(
      key: ValueKey('extraNotu'),
      maxLines: 5,
      decoration: InputDecoration(labelText: "Ek bir not var ise giriniz"),
      onSaved: (val) {
        setState(() {
          _ekstraNot = val;
        });
      },
    );
  }

  _listRequestItems() {
    if (requestItemsDTOs.length > 0) {
      return Expanded(
        flex: 3,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child : Text("Malzeme Listesi"),
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestItemsDTOs.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(requestItemsDTOs[i].name),
                      subtitle: Text(requestItemsDTOs[i].amount.toString()),
                    );
                  }),
            ),

          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (durum == 0) {
      return _myPool();
    } else {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _listRequestItems(),
              Expanded(
                flex: 1,
                child: _listDropdown(),
              ),
              Expanded(
                flex: 2,
                child: _arizaNotuWidget(),
              ),
              Expanded(
                flex: 2,
                child: _extraNotuWidget(),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      color: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          durum = 0;
                          getMyPool();
                          getRequestItems(0);
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        "Kaydet",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
//                      _trySubmit();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _listDropdown() {
    return DropdownButton(
      items: serviceTypes
          .map((item) => DropdownMenuItem(
                child: Text(item.name),
                value: item.id,
              ))
          .toList(),
      value: selectedServiceType,
      onChanged: (i) {
        setState(() {
          selectedServiceType = i;
        });
      },
      isExpanded: true,
      hint: Text("Servis tipi"),
    );
  }

  @override
  void initState() {
    getServiceTypes();
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
            onTap: () {
              setState(() {
                durum = myPool.requestsId;
                getRequestItems(durum);
              });
            },
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
        child: Icon(
          Icons.play_circle_filled,
          color: Colors.orange,
        ),
        onTap: () {
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
