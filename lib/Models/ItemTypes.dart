class ItemTypes {
  int id;
  int requestTypeId;
  Null requestType;
  String name;
  String createTime;
  int createBy;
  String updateTime;
  int updateBy;
  bool isActive;

  ItemTypes(
      {this.id,
        this.requestTypeId,
        this.requestType,
        this.name,
        this.createTime,
        this.createBy,
        this.updateTime,
        this.updateBy,
        this.isActive});

  ItemTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestTypeId = json['requestTypeId'];
    requestType = json['requestType'];
    name = json['name'];
    createTime = json['createTime'];
    createBy = json['createBy'];
    updateTime = json['updateTime'];
    updateBy = json['updateBy'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestTypeId'] = this.requestTypeId;
    data['name'] = this.name;
    data['createTime'] = this.createTime;
    data['createBy'] = this.createBy;
    data['updateTime'] = this.updateTime;
    data['updateBy'] = this.updateBy;
    data['isActive'] = this.isActive;
    return data;
  }
}
