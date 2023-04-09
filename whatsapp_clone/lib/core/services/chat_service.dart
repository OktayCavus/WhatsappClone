import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/models/conversations.dart';

class ChatService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // ! önceden firebase'den map yapısı ile alıyorduk artık obje olarak alacaz
  // * bu yüzden models klasörü oluşturup orda model tanımlayacaz
  Stream<List<Conversations>> getConversations(String userId) {
    // ! members arrayine bakıp arrayContains userId olanlar
    var ref = _firebaseFirestore
        .collection('conversation')
        .where('members', arrayContains: userId);
    // ! ref.snapshots olunca querySnapshot oluyor o yüzden map işlemi uyguluyoruz
    // ! 2 map uygulama sebebi querySnapshot firebase'deki bütün filtrelenen
    // ! conversationları döndürüyor . bu conversation içindeki her bir dökümanı
    // ! map' ten objeye çevirmek istiyoruz bu yüzden 2.map yapıluyır
    // ! map sonucu ıterable dönüyor onu listeye çevirmek gerekiyor
    return ref.snapshots().map((list) => list.docs
        .map((snapshot) => Conversations.fromSnapshot(snapshot))
        .toList());
  }
}
