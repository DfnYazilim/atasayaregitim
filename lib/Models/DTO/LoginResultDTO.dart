class LoginResultDTO {
  String token;
  String expiration;
  String firstName;
  String lastName;
  int role;
  int id;

  LoginResultDTO(
      {this.token,
        this.expiration,
        this.firstName,
        this.lastName,
        this.role,
        this.id});

  LoginResultDTO.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiration'] = this.expiration;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['role'] = this.role;
    data['id'] = this.id;
    return data;
  }
}
