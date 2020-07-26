import 'package:atasayaregitim/Helper/Api.dart';
import 'package:atasayaregitim/Models/Company.dart';
import 'package:atasayaregitim/Models/DTO/GetMyWorkPoolDTO.dart';
import 'package:atasayaregitim/Models/DTO/ItemTypeByIdDTO.dart';
import 'package:atasayaregitim/Models/DTO/NewRequestDTO.dart';
import 'package:atasayaregitim/Models/DTO/RequestItemsDTO.dart';
import 'package:atasayaregitim/Models/DTO/RequestItemsPostDTO.dart';
import 'package:atasayaregitim/Models/DTO/RequestsDTO.dart';
import 'package:atasayaregitim/Models/DTO/SendIdDTO.dart';
import 'package:atasayaregitim/Models/Projects.dart';
import 'package:atasayaregitim/Models/RequestType.dart';
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
  int selectedServiceType,
      selectedCompany,
      selectedProject,
      selectedRequestType,
      selectedRequestTypeItemId;
  var _arizaNotu = '';
  var _ekstraNot = '';
  var _yeniTalepKonuText = '';
  var _yeniTalepAciklamaText = '';
  final _formKey = GlobalKey<FormState>();
  final _formKeyYeni = GlobalKey<FormState>();
  List<RequestItemsDTO> requestItemsDTOs = new List<RequestItemsDTO>();
  List<ServiceTypes> serviceTypes = new List<ServiceTypes>();
  List<Company> companies = new List<Company>();
  List<Project> projects = new List<Project>();
  List<RequestType> requestTypes = new List<RequestType>();
  List<ItemTypeByIdDTO> requestTypesById = new List<ItemTypeByIdDTO>();

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
        flex: 5,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text("Malzeme Listesi - " + durum.toString()),
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestItemsDTOs.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(requestItemsDTOs[i].name),
                      subtitle: Text(requestItemsDTOs[i].amount.toString() +
                          " adet atanan vardır"),
                      trailing: Container(
                        width: 30,
                        child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(labelText: "#"),
                          onChanged: (val) {
                            if (val == "" || val == null) {
                              requestItemsDTOs[i].deliveredAmount = 0;
                            } else {
                              requestItemsDTOs[i].deliveredAmount =
                                  double.parse(val);
                            }
                          },
                        ),
                      ),
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
    } else if (durum == -1) {
      return _yeniTalepOlustur();
    } else {
      return Scaffold(
          floatingActionButton: Row(
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
                width: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Kaydet",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _trySubmit();
                },
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                ],
              ),
            ),
          ));
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
    return Scaffold(
      body: ListView.builder(
          itemCount: myPools.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(myPools[i].companyName),
              subtitle: Text(myPools[i].subject),
              trailing: _trailinOlustur(myPools[i]),
              leading: _iconOlustur(myPools[i]),
            );
          }),
      floatingActionButton: RaisedButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          _yeniTalepOncesi();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  _yeniTalepOncesi() {
    setState(() {
      durum = -1;
    });

    _getCompanies();
    _getProjects();
    _getRequestTypes();
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

  void _basariliToast(String t) {
    Fluttertoast.showToast(
        msg: t,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _trySubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      RequestItemsPostDTO re = new RequestItemsPostDTO();
      RequestsDTO r = new RequestsDTO();

      r.id = durum;
      r.expClosing = _arizaNotu;
      r.note1 = _ekstraNot;
      r.serviceTypeId = selectedServiceType;
      re.requests = r;

      re.requestItems = requestItemsDTOs;

      print(requestItemsDTOs[0].deliveredAmount);
      print(requestItemsDTOs[1].deliveredAmount);
      final result = await api.isKapatma(re);
      if (result == 200) {
        setState(() {
          durum = 0;
          getMyPool();
        });
      } else {
        _hataToast();
      }
    }
  }

  Future<void> _trySubmitSave() async {
    if (_formKeyYeni.currentState.validate()) {
      _formKeyYeni.currentState.save();
      NewRequestDTO dto = new NewRequestDTO();
      dto.itemTypeId = selectedRequestTypeItemId;
      dto.subject = _yeniTalepKonuText;
      dto.projectsId = selectedProject;
      dto.expRequest = _yeniTalepAciklamaText;
      dto.companyId = selectedCompany;
      final result = await api.newRequest(dto);
      if (result == 201) {
        _basariliToast("Yeni talep girildi");
        getMyPool();
        setState(() {
          durum = 0;
          selectedServiceType = selectedCompany = selectedProject =
              selectedRequestType = selectedRequestTypeItemId = null;
          _yeniTalepAciklamaText = '';
          _yeniTalepKonuText = '';
        });
      } else {
        _hataToast();
      }
    }
  }

  Widget _yeniTalepOlustur() {
    return Form(
      key: _formKeyYeni,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: _yeniTalepCari(),
            ),
            Expanded(
              flex: 1,
              child: _yeniTalepProje(),
            ),
            Expanded(
              flex: 1,
              child: _yeniTalepTalepTipi(),
            ),
            Expanded(
              flex: 1,
              child: _yeniTalepUrunTuru(),
            ),
            Expanded(
              flex: 1,
              child: _yeniTalepKonu(),
            ),
            Expanded(
              flex: 1,
              child: _yeniTalepAciklama(),
            ),
            Expanded(
              flex: 1,
              child: _yeniTalepButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCompanies() async {
    final result = await api.getCompanies();
    if (result != null) {
      setState(() {
        companies = result;
      });
    }
  }

  Future<void> _getProjects() async {
    final result = await api.getProjects();
    if (result != null) {
      setState(() {
        projects = result;
      });
    }
  }

  Future<void> _getRequestTypes() async {
    final result = await api.getRequestTypes();
    if (result != null) {
      setState(() {
        requestTypes = result;
      });
    }
  }

  Future<void> _getItemById(int id) async {
    final result = await api.getItemById(id);
    if (result != null) {
      setState(() {
        requestTypesById = result;
      });
    }
  }

  _yeniTalepCari() {
    return DropdownButton(
      items: companies
          .map((item) => DropdownMenuItem(
                child: Text(item.name),
                value: item.id,
              ))
          .toList(),
      value: selectedCompany,
      onChanged: (i) {
        setState(() {
          selectedCompany = i;
        });
      },
      isExpanded: true,
      hint: Text("Cari Seçiniz"),
    );
  }

  _yeniTalepProje() {
    return DropdownButton(
      items: projects
          .map((item) => DropdownMenuItem(
                child: Text(item.name),
                value: item.id,
              ))
          .toList(),
      value: selectedProject,
      onChanged: (i) {
        setState(() {
          selectedProject = i;
        });
      },
      isExpanded: true,
      hint: Text("Proje"),
    );
  }

  _yeniTalepTalepTipi() {
    return DropdownButton(
      items: requestTypes
          .map((item) => DropdownMenuItem(
                child: Text(item.name),
                value: item.id,
              ))
          .toList(),
      value: selectedRequestType,
      onChanged: (i) {
        _getItemById(i);
        setState(() {
          selectedRequestType = i;
          selectedRequestTypeItemId = null;
        });
      },
      isExpanded: true,
      hint: Text("Servis tipi"),
    );
  }

  _yeniTalepUrunTuru() {
    return DropdownButton(
      items: requestTypesById
          .map((item) => DropdownMenuItem(
                child: Text(item.name),
                value: item.id,
              ))
          .toList(),
      value: selectedRequestTypeItemId,
      onChanged: (i) {
        setState(() {
          selectedRequestTypeItemId = i;
        });
      },
      isExpanded: true,
      hint: Text("Proje"),
    );
  }

  _yeniTalepKonu() {
    return TextFormField(
      key: ValueKey('talepKonu'),
      decoration: InputDecoration(labelText: "Konu giriniz"),
      onSaved: (val) {
        setState(() {
          _yeniTalepKonuText = val;
        });
      },
      validator: (value) {
        if (value.isEmpty || value.length < 5) {
          return 'Konu yeterli değil';
        }
        return null;
      },
    );
  }

  _yeniTalepAciklama() {
    return TextFormField(
      key: ValueKey('talepAciklama'),
      decoration: InputDecoration(labelText: "Açıklama giriniz"),
      onSaved: (val) {
        setState(() {
          _yeniTalepAciklamaText = val;
        });
      },
      validator: (value) {
        if (value.isEmpty || value.length < 5) {
          return 'Açıklama yeterli değil';
        }
        return null;
      },
    );
  }

  _yeniTalepButtons() {
    return Row(
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
          width: 20,
        ),
        RaisedButton(
          color: Colors.blue,
          child: Text(
            "Kaydet",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _trySubmitSave();
          },
        )
      ],
    );
  }
}
