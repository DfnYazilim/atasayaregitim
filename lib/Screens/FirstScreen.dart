import 'package:atasayaregitim/Helper/Api.dart';
import 'package:atasayaregitim/Models/DTO/GetMyWorkPoolDTO.dart';
import 'package:atasayaregitim/Models/ItemTypes.dart';
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow,color: Colors.green,),
                Icon(Icons.play_arrow,color: Colors.green,),
              ],
            )
          );
        }
    );
  }
}
