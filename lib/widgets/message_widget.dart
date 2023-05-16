import 'package:flash/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  final MsgModel msgModel;
  final String userEmail;
  const MessageWidget(
      {Key? key, required this.msgModel, required this.userEmail})
      : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  // * State Area
  bool isShowDate = false;
  @override
  Widget build(BuildContext context) {
    final isMe = widget.msgModel.sender == widget.userEmail;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Text(
            widget.msgModel.sender,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          SizedBox(
            height: 2,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (isShowDate) {
                  isShowDate = false;
                } else {
                  isShowDate = true;
                }
              });
            },
            child: Container(
              width: 250,
              margin: EdgeInsets.all(20),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),

                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: isMe ? Colors.green : Colors.redAccent,
                // image: DecorationImage(
                //   alignment: Alignment.topLeft,
                //   image: isMe
                //       ? const AssetImage(
                //           'images/1.jpg',
                //         )
                //       : const AssetImage(
                //           "images/logo.png",
                //         ) as ImageProvider,
                // ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.msgModel.text,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 30,
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: SizedBox(
                                  child: Image(
                                    image: isMe
                                        ? AssetImage(
                                            "images/1.jpg",
                                          )
                                        : const AssetImage(
                                            "images/logo.png",
                                          ) as ImageProvider,
                                  ),
                                  height: 50,
                                  width: 20,
                                ),
                                radius: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: isShowDate,
                      child: Text(
                        widget.msgModel.date.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ]

                  //
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
