//UserModel is created for representing the user in app
class UserModel {
  String? email = "";
  String? password = "";

  UserModel(this.email, this.password);

  UserModel.fromJson(Map json) {
    this.email = json['email'];
    this.password = json['password'];
  }
}
