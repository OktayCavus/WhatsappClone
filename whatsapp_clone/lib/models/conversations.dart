import 'package:cloud_firestore/cloud_firestore.dart';

class Conversations {
  String? idd;
  String? name;
  String? profileImage;
  String? displayMessage;

  Conversations({this.idd, this.name, this.profileImage, this.displayMessage});

  // ! fromSnapshot metoduna DocumentSnapshot göndererek Conversations() objesini oluşturuo
  // ! factory class olarak bize geri dönecek
  // ! factory'i istediğimiz yerde çağıracağız
  factory Conversations.fromSnapshot(DocumentSnapshot snapshot) {
    // ! burası çözüm  bu satırı koyduktan sonra çağırım yaptık
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Conversations(
        idd: snapshot.id,
        name: 'Ali',
        profileImage: 'https://placekitten.com/200/200',
        // ! burası videodan ayrı snapshot.data idi videoda burda böyle kullandık
        displayMessage: data['displayMessage']);
  }
}
