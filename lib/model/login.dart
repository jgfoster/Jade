class Login {
  late int id;
  String address = 'localhost:50378';
  String username = 'DataCurator';
  String password = 'swordfish';

  Login(this.id);

  @override
  int get hashCode {
    return (address + username + password).hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == Login) {
      var rhs = other as Login;
      return address == rhs.address &&
          username == rhs.username &&
          password == rhs.password;
    }
    return false;
  }
}
