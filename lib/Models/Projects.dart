class Project {
  int id;
  int logicalref;
  String code;
  String name;
  String createTime;
  int createBy;
  String updateTime;
  int updateBy;
  bool isActive;

  Project(
      {this.id,
        this.logicalref,
        this.code,
        this.name,
        this.createTime,
        this.createBy,
        this.updateTime,
        this.updateBy,
        this.isActive});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logicalref = json['logicalref'];
    code = json['code'];
    name = json['name'];
    createTime = json['createTime'];
    createBy = json['createBy'];
    updateTime = json['updateTime'];
    updateBy = json['updateBy'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logicalref'] = this.logicalref;
    data['code'] = this.code;
    data['name'] = this.name;
    data['createTime'] = this.createTime;
    data['createBy'] = this.createBy;
    data['updateTime'] = this.updateTime;
    data['updateBy'] = this.updateBy;
    data['isActive'] = this.isActive;
    return data;
  }
}
