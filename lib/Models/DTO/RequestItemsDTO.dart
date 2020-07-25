class RequestItemsDTO {
  int itemID;
  int requestsId;
  String name;
  bool isActive;
  int birim;
  String altBirim;
  double amount;
  double deliveredAmount;
  double remainingAmount;

  RequestItemsDTO(
      {this.itemID,
        this.requestsId,
        this.name,
        this.isActive,
        this.birim,
        this.altBirim,
        this.amount,
        this.deliveredAmount,
        this.remainingAmount});

  RequestItemsDTO.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    requestsId = json['requestsId'];
    name = json['name'];
    isActive = json['isActive'];
    birim = json['birim'];
    altBirim = json['altBirim'];
    amount = json['amount'];
    deliveredAmount = json['deliveredAmount'];
    remainingAmount = json['remainingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['requestsId'] = this.requestsId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['birim'] = this.birim;
    data['altBirim'] = this.altBirim;
    data['amount'] = this.amount;
    data['deliveredAmount'] = this.deliveredAmount;
    data['remainingAmount'] = this.remainingAmount;
    return data;
  }
}
