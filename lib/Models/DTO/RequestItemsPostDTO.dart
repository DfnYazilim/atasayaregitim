import 'RequestItemsDTO.dart';
import 'RequestsDTO.dart';

class RequestItemsPostDTO {
  RequestsDTO requests;
  List<RequestItemsDTO> requestItems;

  RequestItemsPostDTO({this.requests, this.requestItems});

  RequestItemsPostDTO.fromJson(Map<String, dynamic> json) {
    requests = json['Requests'] != null
        ? new RequestsDTO.fromJson(json['Requests'])
        : null;
    if (json['RequestItems'] != null) {
      requestItems = new List<RequestItemsDTO>();
      json['RequestItems'].forEach((v) {
        requestItems.add(new RequestItemsDTO.fromJson(v));
      });
    }
  }
}
