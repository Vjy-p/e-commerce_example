import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/customAppBar.dart';
import 'package:firebase_testing/utils/customTextField.dart';
import 'package:firebase_testing/utils/custom_text.dart';

class ChatScreenStreams extends StatefulWidget {
  const ChatScreenStreams({super.key});

  @override
  State<ChatScreenStreams> createState() => _ChatScreenStreamsState();
}

class _ChatScreenStreamsState extends State<ChatScreenStreams> {
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  List chatList = [];
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initialise() async {
    await channel.ready;

    channel.stream.listen((message) {
      chatList.add(message);
      debugPrint("\nreceived data $message \n $chatList");
      setState(() {});
    });
  }

  sendMessage() {
    // var msg = ChatModel(id: 1, msg: messageController.text);
    // channel.sink.add(msg);
    channel.sink.add(messageController.text);
    // chatList.add(messageController.text);
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    debugPrint("\nmessage sent");
    messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(leading: true, text: "Chat"),
      backgroundColor: primary,
      body: bodyWidget(),
      // body: StreamBuilder(
      //     stream: channel.stream,
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(
      //           child: CircularProgressIndicator.adaptive(),
      //         );
      //       }
      //       if (snapshot.hasData) {
      //         return bodyWidget();
      //       }
      //       if (snapshot.hasError) {
      //         debugPrint("\nerror ${snapshot.error}");
      //         return Center(
      //             child: ElevatedButton(
      //                 onPressed: () {
      //                   initialise();
      //                 },
      //                 child: const Text("Retry")));
      //       }
      //       return const Text("");
      //     }),
    );
  }

  Widget bodyWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 20.h),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: chatList.length,
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              itemBuilder: (context, index) {
                // var own = chatList[index].id == 1 ? "own" : "server";

                return index % 2 == 0
                    ? ownMessage(chatList[index])
                    : receivedMessage(chatList[index]);
              },
            ),
          ),
          textField()
        ],
      ),
    );
  }

  Widget textField() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: white),
          color: white),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          Expanded(
            child: textFieldWidget(
              minLines: 1,
              maxLines: 10,
              context: context,
              hint: "enter message",
              controller: messageController,
              currentFocus: messageFocus,
              borderColor: Colors.transparent,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: IconButton(
                onPressed: () {
                  FocusScope.of(context).hasFocus == true
                      ? FocusScope.of(context).unfocus()
                      : null;
                  debugPrint("\nclick");
                  sendMessage();
                },
                icon: Icon(
                  Icons.send,
                  color: buttonColor,
                ),
              ))
        ],
      ),
    );
  }

  Widget ownMessage(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.zero,
                    bottomRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                  color: white),
              child: customText(
                text: message,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
              padding: EdgeInsets.all(14.w),
              child: customText(text: "U"),
            ),
          )
        ],
      ),
    );
  }

  Widget receivedMessage(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: buttonColor),
              padding: EdgeInsets.all(14.w),
              child: customText(
                text: "R",
                color: tColor2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                  bottomLeft: Radius.zero,
                ),
                color: white,
              ),
              child: customText(
                text: message,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
