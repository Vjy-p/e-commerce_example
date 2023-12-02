import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'package:firebase_testing/models/message_model.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/customToast.dart';
import 'package:firebase_testing/utils/custom_text.dart';

// class ChatScreen extends StatefulWidget {
//   ChatScreen({super.key});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   List chatList = [];
//   ScrollController _scrollController = new ScrollController();
//   final TextEditingController _textController = new TextEditingController();
//   bool _isWriting = false, isChatLoading = false, getUserDataLoading = false;

//   var userData, pageNumber = 1, chatDataLimit = 100;
//   Timer? chatTimer;
//   var socket = IO.io(Constants.baseUrl, <String, dynamic>{
//     'transports': ['websocket']
//   });
//   @override
//   void initState() {
//     getUserData();
//     getChatData();

//     super.initState();
//   }

//   getUserData() async {
//     if (mounted) {
//       setState(() {
//         getUserDataLoading = true;
//       });
//     }
//     // await LoginService.getUserInfo().then((onValue) {
//     //   if (mounted) {
//     //     setState(() {
//     //       userData = onValue['response_data'];
//     //       socketInt();
//     //     });
//     //   }
//     // }).catchError((error) {
//     //   if (mounted) {
//     //     setState(() {
//     //       getUserDataLoading = false;
//     //     });
//     //   }
//     // });
//   }

//   //fetchres info
//   getChatData() async {
//     if (mounted) {
//       setState(() {
//         isChatLoading = true;
//       });
//     }

//     ChatServices.getData(pageNumber: pageNumber, dataLimit: chatDataLimit)
//         .then((response) {
//       if (mounted) {
//         setState(() {
//           chatList.addAll(response['response_data']);
//           Timer(Duration(milliseconds: 300), () {
//             Timer(
//                 Duration(milliseconds: 300),
//                 () => _scrollController
//                     .jumpTo(_scrollController.position.maxScrollExtent));
//           });
//           isChatLoading = false;
//         });
//       }
//     }).catchError((error) {
//       if (mounted) {
//         setState(() {
//           getUserDataLoading = false;
//         });
//       }
//     });
//   }

//   socketInt() {
//     socket.on('connect', (data) {
//       print('connect ');
//     });
//     setState(() {
//       getUserDataLoading = false;
//     });
//     socket.on('disconnect', (_) {
//       print('disconnect');
//     });

//     socket.on('message-user-${userData['_id']}', (data) {
//       if (data != null && mounted) {
//         setState(() {
//           chatList.add(data);
//           Timer(Duration(milliseconds: 300), () {
//             Timer(
//                 Duration(milliseconds: 300),
//                 () => _scrollController
//                     .jumpTo(_scrollController.position.maxScrollExtent));
//           });
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     if (_scrollController != null) _scrollController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: customAppBar(text: "chat"),
//       body: isChatLoading || getUserDataLoading
//           ? CustomLoading().circularLoading()
//           : Stack(
//               fit: StackFit.expand,
//               children: <Widget>[
//                 Column(
//                   children: <Widget>[
//                     Expanded(
//                       child: new ListView.builder(
//                         controller: _scrollController,
//                         padding: new EdgeInsets.all(8.0),
//                         itemCount:
//                             chatList.length == null ? 0 : chatList.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           bool isOwnMessage = false;
//                           if (chatList[index]['sentBy'] == 'USER') {
//                             isOwnMessage = true;
//                           }
//                           return isOwnMessage
//                               ? _ownMessage(
//                                   chatList[index]['message'],
//                                 )
//                               : _message(
//                                   chatList[index]['message'],
//                                 );
//                         },
//                       ),
//                     ),
//                     new Divider(height: 1.0),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: new Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               new Flexible(
//                                 child: new TextField(
//                                   maxLines: 1,
//                                   controller: _textController,
//                                   onChanged: (String txt) {
//                                     if (mounted) {
//                                       setState(() {
//                                         _isWriting = txt.length > 0;
//                                       });
//                                     }
//                                   },
//                                   onSubmitted: _submitMsg,
//                                   decoration: new InputDecoration.collapsed(
//                                       hintText: "ENTER_TEXT_HERE"),
//                                 ),
//                               ),
//                               new Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey,
//                                 ),
//                                 child: new IconButton(
//                                   icon: new Icon(
//                                     Icons.send,
//                                     color: Colors.black,
//                                     size: 30,
//                                   ),
//                                   onPressed: _isWriting
//                                       ? () => _submitMsg(_textController.text)
//                                       : null,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//     );
//   }

//   Widget _ownMessage(String message) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.only(
//                         top: 12.0, bottom: 14.0, left: 16.0, right: 16.0),
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.6,
//                     ),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(40),
//                           topRight: Radius.circular(0),
//                           bottomRight: Radius.circular(40),
//                           bottomLeft: Radius.circular(40),
//                         ),
//                         color: Colors.black.withOpacity(0.60)),
//                     child: Text(
//                       message,
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _message(String message) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.only(
//                         top: 12.0, bottom: 14.0, left: 16.0, right: 16.0),
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.6,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(0),
//                         topRight: Radius.circular(40),
//                         bottomRight: Radius.circular(40),
//                         bottomLeft: Radius.circular(40),
//                       ),
//                       color: Color(0xFFF0F0F0),
//                     ),
//                     child: Text(
//                       message,
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _submitMsg(String txt) async {
//     Timer(Duration(milliseconds: 300), () {
//       Timer(
//           Duration(milliseconds: 300),
//           () => _scrollController
//               .jumpTo(_scrollController.position.maxScrollExtent));
//     });
//     _textController.clear();
//     if (mounted) {
//       setState(() {
//         _isWriting = false;
//       });
//     }
//     var chatInfo = {
//       "message": txt,
//       "sentBy": 'USER',
//       "userName": userData['firstName'],
//       "userId": userData['_id']
//     };
//     socket.emit('message-user-to-store', chatInfo);

//     chatList.add(chatInfo);
//   }
// }

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  List<MessageModel> chatList = [];

  // Socket socket = IO.io(
  //     'http://192.168.0.122:5555',https://socket.excopro.com
  //     OptionBuilder()
  //         .setTransports(['websocket']) // for Flutter or Dart VM
  //         .disableAutoConnect() // disable auto-connection
  //         // .setExtraHeaders({'foo': 'bar'}) // optional
  //         .build());

  late Socket socket;

  @override
  void initState() {
    initialise();
    super.initState();
  }

  initialise() {
    // String token=await Common.getToken();

    // debugPrint("\ntoken $token");
    socket = IO.io('http://localhost:5555', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': ""}
    });

    socket.connect();
    debugPrint("\nsocket connected ${socket.connected}");

    socket.on('connection', (data) {
      chatList.add(MessageModel.fromJson(data));
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      setState(() {});
    });

    socket.on('message', (data) {
      debugPrint("\nsocket data $data");
      setState(() {
        if (data.isBlank) {
        } else {
          chatList.add(MessageModel.fromJson(data));
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    });

    // socket.on('connect', (_) => print('connect: ${socket.id}'));

    socket.on('disconnect', (_) => print('\nDisconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  sendMessage() {
    FocusScope.of(context).unfocus();

    MessageModel message = MessageModel(
        id: 1,
        type: 'user',
        createdAt: DateTime.now(),
        message: messageController.text);

    socket.emit("message", message);

    chatList.add(message);

    debugPrint("\nmessage sent");
    messageController.clear();
    setState(() {});
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  responseEvent() {
    //response
    socket.emitWithAck("update item", {"accept": false},
        ack: (resp) => {
              debugPrint("\n9999999999999999  $resp"),
              if (resp['status'] == 1)
                {
                  chatList.add(resp['message']),
                  setState(() {}),
                }
              else
                {customToast(context: context, text: resp['message'])}
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(leading: true, text: ""),
      backgroundColor: Colors.cyanAccent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: chatList.length,
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    var user = chatList[index].type;
                    return user == 'user'
                        ? ownMessage(chatList[index])
                        : receivedMessage(chatList[index]);
                  },
                )),
            textField()
          ],
        ),
      ),
    );
  }

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white),
            color: Colors.white),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: [
            Expanded(
              child: textFieldWidget(
                context: context,
                hint: "enter message",
                controller: messageController,
                currentFocus: messageFocus,
                borderColor: Colors.transparent,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton(
                  onPressed: () {
                    debugPrint("\nclick");
                    sendMessage();
                    // responseEvent();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget ownMessage(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message.createdAt.toString(),
            style: customTextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        color: Colors.white),
                    child: Text(
                      message.message,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withOpacity(0.2)),
                padding: EdgeInsets.all(14),
                child: customText(text: "U"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget receivedMessage(MessageModel message) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message.createdAt.toString(),
            style: customTextStyle(fontSize: 14, color: Colors.grey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withOpacity(0.2)),
                padding: const EdgeInsets.all(14),
                child: customText(text: "R"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(0),
                      ),
                      color: Color(0xFFF0F0F0),
                    ),
                    child: Text(
                      message.message,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
