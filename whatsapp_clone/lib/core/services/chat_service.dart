import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsapp_clone/models/conversations.dart';
import 'package:whatsapp_clone/models/profile.dart';

class ChatService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // ! önceden firebase'den map yapısı ile alıyorduk artık obje olarak alacaz
  // * bu yüzden models klasörü oluşturup orda model tanımlayacaz
  Stream<List<Conversations>> getConversations(String userId) {
    // ! members arrayine bakıp arrayContains userId olanlar
    var ref = _firebaseFirestore
        .collection('conversation')
        .where('members', arrayContains: userId);

// ! bütün userları local değişkene tamamlamaya çalışacaz
// ! bu kodla da future'dan stream'e çeviriyoruz
    var profileStreams = getContacts().asStream();

    var conversationsStream = ref.snapshots();
// ! burası 2 streami birleştirmek
    return Rx.combineLatest2(
        conversationsStream,
        profileStreams,
        (QuerySnapshot conversation, List<Profile> profiles) =>
            conversation.docs.map((snapshot) {
              // ! members arrayi içindeki bize ait olmayan user'ı çekip
              // ! bu bilgiyi fromSnapshot'a yollucaz

              List<String> members = List.from(snapshot['members']);

              var profile = profiles.firstWhere((element) =>
                  element.id ==
                  members.firstWhere((member) => member == userId));
              return Conversations.fromSnapshot(snapshot, profile);
            }).toList());

    // ! ref.snapshots olunca querySnapshot oluyor o yüzden map işlemi uyguluyoruz
    // ! 2 map uygulama sebebi querySnapshot firebase'deki bütün filtrelenen
    // ! conversationları döndürüyor . bu conversation içindeki her bir dökümanı
    // ! map' ten objeye çevirmek istiyoruz bu yüzden 2.map yapıluyır
    // ! map sonucu ıterable dönüyor onu listeye çevirmek gerekiyor
    /* return ref.snapshots().map((list) => list.docs
        .map((snapshot) => Conversations.fromSnapshot(snapshot))
        .toList());*/
  }

  Future<List<Profile>> getContacts() async {
    var ref = _firebaseFirestore.collection('profile');

    var documents = await ref.get();

// ! QuerySnapshottan profile'a çeviriyoruz burda
    return documents.docs
        .map((snapshot) => Profile.fromSnapshot(snapshot))
        .toList();
  }

  Future<Conversations> startConversation(User user, Profile profile) async {
    var ref = _firebaseFirestore.collection('conversation');
// ! burda 2 kişi arasında sohbeti başlattık
    var documentRef = await ref.add({
      'displayMessage': ' ',
      'members': [user.uid, profile.id]
    });

    return Conversations(
        idd: documentRef.id,
        displayMessage: "",
        name: profile.userName,
        profileImage: profile.image);
  }
}
