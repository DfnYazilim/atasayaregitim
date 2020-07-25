class RequestsDTO {
  int id;
  String expClosing;
  String note1;
  int serviceTypeId;

  RequestsDTO({this.id, this.expClosing, this.note1, this.serviceTypeId});

  RequestsDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expClosing = json['expClosing'];
    note1 = json['note1'];
    serviceTypeId = json['serviceTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expClosing'] = this.expClosing;
    data['note1'] = this.note1;
    data['serviceTypeId'] = this.serviceTypeId;
    return data;
  }
}
