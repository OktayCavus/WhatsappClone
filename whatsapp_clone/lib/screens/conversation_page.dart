import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/core/locator.dart';
import 'package:whatsapp_clone/models/conversations.dart';
import 'package:whatsapp_clone/viewmodels/conversation_model.dart';

class ConversationPage extends StatefulWidget {
  String userId;
  Conversations conversation;

  ConversationPage(
      {super.key, required this.userId, required this.conversation});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  CollectionReference? _ref;

  FocusNode? _focusNode;

  ScrollController? _scrollController;
  final TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    _ref = FirebaseFirestore.instance
        // ! widget'a gönderilen collectionID yi yolluyoruz
        .collection('conversation/${widget.conversation}/messages');

    // ! focusNode'u initialize edelim
    _focusNode = FocusNode();
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    // ! dispose widget ekrandan kaybolduğunda focus node memoryden silinecek
    _focusNode?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var model = getIt<ConversationModel>();
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: -5,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage('${widget.conversation.profileImage}'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('${widget.conversation.name}'),
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
                child: GestureDetector(
                  onTap: () => _focusNode!.unfocus(),
                  child: StreamBuilder(
                      // ! orderBy metodu yollanan mesajların firebase'e sırası ile kaydedilmesi için
                      stream:
                          model.getConversation('${widget.conversation.idd}'),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? const CircularProgressIndicator()
                            : ListView(
                                controller: _scrollController,
                                children: snapshot.data!.docs
                                    .map((document) => ListTile(
                                          subtitle: Align(
                                              alignment: widget.userId !=
                                                      document['senderID']
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
              ),
              Consumer<ConversationModel>(
                builder: (context, value, child) {
                  return model.mediaUrl.isEmpty
                      ? Container()
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                              width: 150, child: Image.network(model.mediaUrl)),
                        );
                },
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
                            focusNode: _focusNode,
                            // ! controller ile text fiedlin içindeki yazıları alabiliriz
                            controller: _editingController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message'),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await model.uploadMedia(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.attach_file)),
                        IconButton(
                            onPressed: () async {
                              await model.uploadMedia(ImageSource.camera);
                            },
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
                            await model.add({
                              'senderID': widget.userId,
                              'message': _editingController.text,
                              'timeStamp': DateTime.now(),
                              'media': model.mediaUrl
                            });
                            _editingController.text = '';
                            // ! offset listede nerede olduğumuzu gösteriyor en başta istiyorsak 0 veriyoruz
                            // ! en alta isteyince _scrollController!.position.maxScrollExtent, bunu veriyoruz
                            // ! dynamic yaptık liste ne kadar uzarsa gene en sona gelecek
                            _scrollController!.animateTo(
                                _scrollController!.position.maxScrollExtent,
                                duration: const Duration(microseconds: 200),
                                curve: Curves.easeIn);
                          },
                          icon: const Icon(Icons.send))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
