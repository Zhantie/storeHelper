import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fitness/constants/api_consts.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _openAI = OpenAI.instance.build(
    token: API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: "User",
    lastName: "last name",
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: "Supermarkt",
    lastName: "help",
  );

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Albert heijn Assistent',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Colors.blue,
          textColor: Colors.white,
        ),
        onSend: (ChatMessage message) {
          getChatResponse(message);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_gptChatUser);
    });
    List<Messages> _messagesHistory = _messages.reversed.map((message) {
      if (message.user == _currentUser) {
        return Messages(
          role: Role.user,
          content: message.text,
        );
      } else {
        return Messages(
          role: Role.assistant,
          content: message.text,
        );
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: [ Messages(
          role: Role.assistant,
          content: 'Als assistent binnen Albert Heijn bij filiaal Albert Heijn Buurmalseplein weet jij alles te vinden en ken jij alle locaties van elk product. Het is van cruciaal belang om vragen buiten deze scope niet te beantwoorden. Het is belangrijk om kort, snel en duidelijk te reageren, maar wel op een klantvriendelijke manier. Als een klant specifiek vraagt naar een product, leg je het bijvoorbeeld uit als gangpad 4, links, meter 2, 3e plank. Als een klant vraagt waar hij of zij een product kan vinden, leg je eerst uit waar het product zich bevindt. Als de klant aangeeft het niet te kunnen vinden, verwijs je pas door naar een medewerker. Voor allergieën geef je kort aan of het product veilig is en bied je indien mogelijk alternatieven aan. Als een product niet op voorraad is, geef je de reden, zoals een foutieve levering, kwaliteitsproblemen of een slechte oogst. Houd je antwoorden kort en vriendelijk, om efficiënt te blijven binnen de kosten per token. Vergeet niet dat het heel belangrijk is om vragen buiten deze scope niet te beantwoorden.',
        ).toJson(),
        ..._messagesHistory.map((message) => message.toJson()).toList(),
      ],
      // messages: _messagesHistory.map((message) => message.toJson()).toList(),
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content),
          );
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}
