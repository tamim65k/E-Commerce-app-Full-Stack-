// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:amazon_clone/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double totalPrice;

  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? map['_id'] as String,
      products: List<Product>.from(
        (map['products'] as List).map((x) => Product.fromMap(x)),
      ),
      quantity:
          map['quantity'] != null
              ? List<int>.from(map['quantity'] as List)
              : <int>[],
      address: map['address'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      orderedAt:
          map['orderAt'] is int
              ? map['orderAt'] as int
              : int.tryParse(map['orderAt']?.toString() ?? '0') ?? 0,
      status:
          map['status'] is int
              ? map['status'] as int
              : int.tryParse(map['status']?.toString() ?? '0') ?? 0,
      totalPrice: map['totalPrice'].toDouble() ?? 0.0 ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
