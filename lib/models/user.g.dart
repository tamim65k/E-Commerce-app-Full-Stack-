// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['_id'] as String,
  name: json['name'] as String,
  password: json['password'] as String,
  email: json['email'] as String,
  address: json['address'] as String,
  type: json['type'] as String,
  token: json['token'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'password': instance.password,
  'email': instance.email,
  'address': instance.address,
  'type': instance.type,
  'token': instance.token,
};
