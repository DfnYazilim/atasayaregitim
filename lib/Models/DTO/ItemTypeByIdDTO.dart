class ItemTypeByIdDTO {
  int id;
  int requestTypeId;
  String name;

  ItemTypeByIdDTO({this.id, this.requestTypeId, this.name});

  ItemTypeByIdDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestTypeId = json['requestTypeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requestTypeId'] = this.requestTypeId;
    data['name'] = this.name;
    return data;
  }
}
