import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/locator.dart';
import 'package:whatsapp_clone/screens/contacts_page.dart';
import 'package:whatsapp_clone/screens/index.dart';
import 'package:whatsapp_clone/viewmodels/main_model.dart';

class WhatsappMain extends StatefulWidget {
  const WhatsappMain({super.key});

  @override
  State<WhatsappMain> createState() => _WhatsappMainState();
}

class _WhatsappMainState extends State<WhatsappMain>
    with SingleTickerProviderStateMixin {
  bool _showMessage = true;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      // ! tabController'a listener ekledik ki _showMessage'ı güncelleyebilelim
      _showMessage = _tabController.index != 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = getIt<MainModel>();
    return Scaffold(
      // ! appBarın saydam olmasını sağlıyor
      extendBodyBehindAppBar: true,
      // ! NestedScrollView bütün widgetları kaydırmamızı sağlıyor
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_vert))
                ],
                // ! bu 2 parametre yukarı kaydırınca appbarin görünmemesini
                // ! alta kaydırınca geri gelmesini sağlıyor
                floating: true,
                title: const Text('Whatsapp Clone'),
              )
            ];
          },
          body: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: TabBar(controller: _tabController, tabs: const [
                  Tab(
                    icon: Icon(Icons.camera),
                  ),
                  Tab(
                    text: 'Chats',
                  ),
                  Tab(
                    text: 'Status',
                  ),
                  Tab(
                    text: 'Calls',
                  ),
                ]),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  const CameraPage(),
                  ChatsPage(),
                  const StatusPage(),
                  const CallsPage(),
                ]),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showMessage
          ? FloatingActionButton(
              child: const Icon(Icons.message),
              // ! method future dönüyor dikkat
              onPressed: () {
                // ! BURANIN DÜZELTİLMESİ LAZIM
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactsPage(),
                ));
              })
          : null,
    );
  }
}
