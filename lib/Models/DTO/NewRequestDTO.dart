class NewRequestDTO {
  int itemTypeId;
  String subject;
  int projectsId;
  String expRequest;
  int companyId;

  NewRequestDTO(
      {this.itemTypeId,
        this.subject,
        this.projectsId,
        this.expRequest,
        this.companyId});

  NewRequestDTO.fromJson(Map<String, dynamic> json) {
    itemTypeId = json['ItemTypeId'];
    subject = json['Subject'];
    projectsId = json['projectsId'];
    expRequest = json['ExpRequest'];
    companyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemTypeId'] = this.itemTypeId;
    data['Subject'] = this.subject;
    data['projectsId'] = this.projectsId;
    data['ExpRequest'] = this.expRequest;
    data['CompanyId'] = this.companyId;
    return data;
  }
}
