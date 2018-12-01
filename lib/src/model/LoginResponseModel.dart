class LoginResponseModel {
  Map<String, dynamic> json;

  LoginResponseModel(this.json);

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    this.json = json['json'];
  }
}
