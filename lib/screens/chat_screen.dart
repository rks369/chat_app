import 'package:chat_app/components/mesaage_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();

  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String text;
  late bool isMe;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser()
  async {
    try{
      final user = _auth.currentUser!;
      loggedInUser = user;
      print(user.email);
    }catch(e)
    {
      print(e);
    }
  }

  // void getMessages() async
  // {
  //   final messages = await _fireStore.collection('message').get();
  //   for(var message in messages.docs)
  //     {
  //         print(message.data());
  //     }
  // }


  void messageStream() async{
    await for(var snapshot in _fireStore.collection('message').snapshots() ){
      for(var message in snapshot.docs)
        {
          print(message.data());
        }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('message').orderBy('time').snapshots(),
                builder: (context,snapshot)
            {

              if(!snapshot.hasData)
                {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                  final messages = snapshot.data!.docs.reversed;
              List<MessageBubble> messageWidgets =[];
                  for(var message in messages)
                    {
                      final text = message.get('text');
                      final sender = message.get('sender');
                      final messageWidget = MessageBubble(sender: sender, text: text,isMe:sender==loggedInUser.email);
                      messageWidgets.add(messageWidget);
                    }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                  children: messageWidgets,
                ),
              );
            },),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        text=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('message').add({"text":text,"sender":loggedInUser.email,"time":DateTime.now().millisecondsSinceEpoch,});
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
