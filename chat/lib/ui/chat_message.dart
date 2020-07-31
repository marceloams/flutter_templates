import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  //constructor to get the data
  ChatMessage(this.data, this.mine);

  //message data map
  final Map<String, dynamic> data;

  //boolean to indicate if the current user is the person that sent the message
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          !mine ? //shows the message user info on the left if it is not from the current user
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar( //shows user image
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container(),
          Expanded( //to occupy all the space available
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start, //verify the message sender to align the message on the left or on the right
              children: <Widget>[
                data['imgUrl'] != null ?  //verify if message will be an image or a text
                    Image.network(data['imgUrl'], width: 250.0,) : //shows an image
                    Text( //shows a text
                      data['text'],
                      textAlign: mine ? TextAlign.end : TextAlign.start, //verify the message sender to align the text on the left or on the right
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                Text( //shows the sender name info
                  data['senderName'],
                  style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            )
          ),
          mine ? //shows the message user info on the right if it is from the current user
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar( //shows user image
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
