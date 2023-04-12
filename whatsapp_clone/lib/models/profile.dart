import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? id;
  String? userName;
  String? image;

  Profile({this.id, this.userName, this.image});

  // ! firebasedeki profile bize map dönüyordu onu objeye çevirmek istiyoruz
  factory Profile.fromSnapshot(DocumentSnapshot snapshot) {
    return Profile(
        id: snapshot.id,
        userName: snapshot['userName'],
        image: snapshot['image']);
  }
}
