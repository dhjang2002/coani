
import 'dart:convert';
import 'dart:io';

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
      };
}

main() {
  User user = new User("aaa","a@a.com");
  var map = user.toJson();
  print(map);

}