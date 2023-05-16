class Users {
  late String uid;
  late String name;
  late String email;
  late String password;
  late String type;

  Users({required this.uid,required this.name, required this.email, required this.password, required this.type});

  Users.fromMap(dynamic obj) {
    uid = obj['uid'].toString();
    name = obj['name'].toString();
    email = obj['email'].toString();
    type = obj['type'].toString();
    password = obj['password'].toString();
  }
}
