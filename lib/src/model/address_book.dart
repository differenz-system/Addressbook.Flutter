//AddressBook model class created for representing the data in one address entry in our app or database
class AddressBook {
  String kId = "id";
  String kName = "name";
  String kEmail = "email";
  String kContactUs = "contact_number";
  String kIsActive = "isactive";

  int? _id;
  String? _name;
  String? _email;
  String? _contact_number;
  int? _isactive;

  AddressBook(this._name, this._email, this._contact_number, this._isactive);

  AddressBook.withId(
      this._id, this._name, this._email, this._contact_number, this._isactive);

  int? get isactive => _isactive;

  String? get contact_number => _contact_number;

  String get email => _email!;

  String get name => _name!;

  int? get id => _id;

  set isactive(int? value) {
    _isactive = value;
  }

  set contact_number(String? value) {
    _contact_number = value;
  }

  set email(String value) {
    if (value.length <= 255) _email = value;
  }

  set name(String value) {
    if (value.length <= 255) _name = value;
  }

  set id(int? value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[kName] = _name;
    map[kEmail] = _email;
    map[kContactUs] = _contact_number;
    map[kIsActive] = _isactive;
    if (_id != null) {
      map[kId] = _id;
    }
    return map;
  }

  AddressBook.fromObject(dynamic object) {
    this._id = object[kId];
    this._name = object[kName];
    this._email = object[kEmail];
    this._contact_number = object[kContactUs];
    this._isactive = object[kIsActive];
  }
}
