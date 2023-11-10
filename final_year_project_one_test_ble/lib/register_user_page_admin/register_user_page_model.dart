class RegisterUserPageModel {
  String name;
  String email;
  String password;
  String role;
  String id;
  String imei;
  String firstLogin;

  RegisterUserPageModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.id,
    required this.imei,
    required this.firstLogin,
  });

  Map<String, dynamic> registerToMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'id': id,
      'imei': imei,
      'firstLogin': firstLogin,
    };
  }
}
