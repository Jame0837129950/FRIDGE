// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {

final String urlImage;
final Timestamp timeReceive;
final Timestamp timeExpire;
  ProductModel({
    required this.urlImage,
    required this.timeReceive,
    required this.timeExpire,
  });


  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'urlImage': urlImage,
      'timeReceive': timeReceive,
      'timeExpire': timeExpire,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      urlImage: (map['urlImage'] ?? '') as String,
      timeReceive: (map['timeReceive'] ),
      timeExpire: (map['timeExpire'] ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
