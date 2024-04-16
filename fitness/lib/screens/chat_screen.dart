import 'package:fitness/constants/constants.dart';
import 'package:fitness/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;

  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Image.asset(AssetsManager.appLogo),
        ),
        title: const Text('Supermaket help'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.blue),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const Text('Hello this is a massage');
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.blue,
                size: 30.0,
              ),
              SizedBox(height: 15.0),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            style: const TextStyle(color: Colors.black),
                            controller: textEditingController,
                            onSubmitted: (value) => {
                                  // to do send message
                                },
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Hoe kan ik u helpen?',
                              hintStyle: TextStyle(color: Colors.grey),
                            )),
                      ),
                      IconButton(
                        onPressed: () {
                          // to do send message
                        },
                        icon: const Icon(Icons.send, color: Colors.blue),
                      )
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
