import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.sender,required this.text,required this.isMe});

  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style: const TextStyle(fontSize: 12.0,color: Colors.black54),),
          Material(
            borderRadius: isMe? const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft:Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)
            ):const BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft:Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)
            ),
            elevation: 5.0,
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text(
                text,style:  TextStyle(color: isMe?Colors.white:Colors.lightBlueAccent,fontSize: 15.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
