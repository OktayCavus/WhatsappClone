import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/models/conversations.dart';
import 'package:whatsapp_clone/screens/conversation_page.dart';
import 'package:whatsapp_clone/viewmodels/chats_model.dart';

class ChatsPage extends StatelessWidget {
  //final String userId = '7y6ZJDW2maQI1oTNjgxM0rpDeDn1';
  final String userId = 'kWjle2wQNzUn3ruRFYeCLjLMpuV2';
  const ChatsPage({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    var model = GetIt.instance<ChatsModel>();

    return ChangeNotifierProvider(
      create: (context) => model,
      child: StreamBuilder<List<Conversations>>(
        // ! burayı firestore_db ye yolladık sonra model üzerinden çağırdık
        // ! where filtreleme yapmak için ilki sorgulamak istediğimiz alan (members)
        stream:
            //firebaseFirestore.collection('conversation').where('members' , arrayContains: userId).snapshots();
            model.conversations(userId),

        builder: (context, snapshot) {
          // * Stream'de bir hata oluşursa o hatayı döndürecek
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          // ! verinin yüklenme durumu olduğunda loading yazacak
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            // ! children normalde widget alır biz bu şekilde onu dinamic
            // * hale getirdik
            // * sohbetler kadar listtile oluşturacak
            // * modelden sonra docs kaldırıldı snapshot.data!.docs 'tu
            children: snapshot.data!
                .map((doc) => ListTile(
                      onTap: () {
                        model.navigatorService.navigateTo(ConversationPage(
                            userId: userId,
                            conversationId: (doc.idd).toString()));
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage((doc.profileImage).toString()),
                      ),
                      title: Text(
                        (doc.name).toString(),
                      ),
                      subtitle: Text((doc.displayMessage).toString()),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('19:30'),
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff25D366),
                            ),
                            height: 20,
                            width: 20,
                            child: const Text(
                              textScaleFactor: 0.8,
                              '20',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
