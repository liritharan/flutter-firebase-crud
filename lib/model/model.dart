import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String? id;
  final String? name;
  final String? city;

  UserModel({this.name, this.city, this.id});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot['name'],
      city: snapshot['city'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "city": city,
    "id": id,
  };
}