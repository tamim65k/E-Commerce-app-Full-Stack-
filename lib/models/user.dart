
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String password;
  final String email;
  final String address;
  final String type;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.address,
    required this.type,
    required this.token,
  });

	factory User.fromJson(Map<String, dynamic> json) =>
			_$UserFromJson(json);
	Map<String, dynamic> toJson() => _$UserToJson(this);
}
	