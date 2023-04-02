import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  String userId;
  String conversationId;

  ConversationPage(
      {super.key, required this.userId, required this.conversationId});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  CollectionReference? _ref;
  final TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    _ref = FirebaseFirestore.instance
        // ! widget'a gönderilen collectionID yi yolluyoruz
        .collection('conversation/${widget.conversationId}/messages');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: NetworkImage('https://placekitten.com/200/200'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text('data'),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.videocam_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/peakpx.jpg'))),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  // ! orderBy metodu yollanan mesajların firebase'e sırası ile kaydedilmesi için
                  stream: _ref!.orderBy('timeStamp').snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? const CircularProgressIndicator()
                        : ListView(
                            children: snapshot.data!.docs
                                .map((document) => ListTile(
                                      title: Align(
                                          alignment: widget.userId !=
                                                  document['senderID']
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: Text(
                                                document['message'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ))),
                                    ))
                                .toList());
                  }),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.tag_faces,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          // ! controller ile text fiedlin içindeki yazıları alabiliriz
                          controller: _editingController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type a message'),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt_outlined)),
                    ],
                  ),
                )),
                Container(
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          await _ref!.add({
                            'senderID': widget.userId,
                            'message': _editingController.text,
                            'timeStamp': DateTime.now()
                          });
                          _editingController.text = '';
                        },
                        icon: const Icon(Icons.send))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
