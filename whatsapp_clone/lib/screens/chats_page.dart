import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/conversation_page.dart';

class ChatsPage extends StatelessWidget {
  //final String userId = '7y6ZJDW2maQI1oTNjgxM0rpDeDn1';
  final String userId = 'kWjle2wQNzUn3ruRFYeCLjLMpuV2';
  ChatsPage({super.key});
  @override
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // ! where filtreleme yapmak için ilki sorgulamak istediğimiz alan (members)
      stream: firebaseFirestore
          .collection('conversation')
          .where('members', arrayContains: userId)
          .snapshots(),
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
          children: snapshot.data!.docs
              .map((doc) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                    userId: userId,
                                    conversationId: doc.id,
                                  )));
                    },
                    leading: const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://placekitten.com/200/200'),
                    ),
                    title: const Text(
                      'ali',
                    ),
                    subtitle: Text(doc['displayMessage']),
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
    );
  }
}
