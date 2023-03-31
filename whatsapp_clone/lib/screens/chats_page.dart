import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  ChatsPage({super.key});
  @override
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebaseFirestore.collection('chats').snapshots(),
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
                    leading: const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://placekitten.com/200/200'),
                    ),
                    title: Text(
                      doc['name'],
                    ),
                    subtitle: Text(doc['message']),
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
