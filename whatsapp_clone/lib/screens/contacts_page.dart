import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/locator.dart';
import 'package:whatsapp_clone/models/profile.dart';
import 'package:whatsapp_clone/viewmodels/contacts_model.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
              onPressed: () {
                // ! showSearch flutterın bize sunduğu bir method
                // ! delegate parametresi arama işleminin kontrolünü sağlar
                showSearch(context: context, delegate: ContactSearchDelegate());
              },
              icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: const ContactsList(),
    );
  }
}

class ContactsList extends StatelessWidget {
  final String query;
  const ContactsList({this.query = "", super.key});

  @override
  Widget build(BuildContext context) {
    var model = getIt<ContactsModel>();
    return FutureBuilder(
        future: model.getContacts(query),
        builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xff25D366),
                  child: Icon(
                    Icons.group,
                    color: Colors.white,
                  ),
                ),
                title: Text('New Group'),
              ),
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xff25D366),
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                ),
                title: Text('New Contact'),
              ),
              ...snapshot.data!
                  .map((profile) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff25D366),
                          backgroundImage: NetworkImage('${profile.image}'),
                        ),
                        title: Text('${profile.userName}'),
                      ))
                  .toList(),
            ],
          );
        });
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    // ! sadece yapılan değişiklikler temaya yansıması için copyWith kullandık
    return theme.copyWith(primaryColor: const Color(0xff075e54));
  }

  // ! buildActions arama kutusunun sağ tarafında yer alacak olan widget'ı oluşturur
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            showResults(context);
          },
          icon: const Icon(Icons.search))
    ];
  }

// ! buildLeading arama kutusunun sol tarafında yer alacak olan widget'ı oluşturmak için kullanılır.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          // ! null yeri result araştır
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

// ! ullanıcının arama kutusuna bir şeyler yazdıktan sonra gösterilecek olan sonuçları oluşturmak için kullanılır
  @override
  Widget buildResults(BuildContext context) {
    return ContactsList(
      query: query,
    );
  }

// ! searchDelegate'yi açınca kullanıcıya gösterdiği widget
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Start Search to Chat'),
    );
  }
}
