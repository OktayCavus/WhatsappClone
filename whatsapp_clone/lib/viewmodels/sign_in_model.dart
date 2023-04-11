import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/core/locator.dart';
import 'package:whatsapp_clone/core/services/auth_service.dart';
import 'package:whatsapp_clone/viewmodels/base_model.dart';
import 'package:whatsapp_clone/whatsapp_main.dart';

//! basemodel'de changenotifier yaptık o yüzden  buraya extend ettik tek tek
// changenotifier işlemleri yapmamak için bir class oldu elimizde
class SignInModel extends BaseModel {
  final AuthService _authService = getIt<AuthService>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? get currentUser => _authService.currentUser;

  Future<void> signInn(String userName) async {
    if (userName.isEmpty) return;
    busy = true;

    try {
      var user = await _authService.signIn();
// ! koleksiyon id'lerini userId ile aynı yapmak istiyoruz çağırması kolay olması için
// ! bu yüzden .doc kullandık
      await _firebaseFirestore.collection('profile').doc(user.user!.uid).set(
          {'userName': userName, 'image': 'https://placekitten.com/200/200'});
// ! burayı basemodeli extend ettiğimiz için ordan çekiyor
      await navigatorService.navigateAndReplace(const WhatsappMain());
    } catch (e) {
      busy = false;
      print('Hata ????*** $e');
    }

    busy = false;
  }
}
