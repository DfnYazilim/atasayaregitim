class GetMyWorkPoolDTO {
  int requestsId;
  int companyId;
  String companyName;
  bool isActive;
  int id;
  String subject;
  String name;
  double priority;
  int requestStatusId;
  String userName;
  int date;

  GetMyWorkPoolDTO(
      {this.requestsId,
      this.companyId,
      this.companyName,
      this.isActive,
      this.id,
      this.subject,
      this.name,
      this.priority,
      this.requestStatusId,
      this.userName,
      this.date});

  GetMyWorkPoolDTO.fromJson(Map<String, dynamic> json) {
    requestsId = json['requestsId'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    isActive = json['isActive'];
    id = json['id'];
    subject = json['subject'];
    name = json['name'];
    priority = json['priority'];
    requestStatusId = json['requestStatusId'];
    userName = json['userName'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestsId'] = this.requestsId;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['isActive'] = this.isActive;
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['name'] = this.name;
    data['priority'] = this.priority;
    data['requestStatusId'] = this.requestStatusId;
    data['userName'] = this.userName;
    data['date'] = this.date;
    return data;
  }
}
