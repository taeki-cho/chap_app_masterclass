import 'package:chap_app_masterclass/components/chat_bubble.dart';
import 'package:chap_app_masterclass/components/my_textfield.dart';
import 'package:chap_app_masterclass/services/auth/auth_service.dart';
import 'package:chap_app_masterclass/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 텍스트 컨트롤러
  final TextEditingController _messageController = TextEditingController();

  // 인증 및 채팅 서비스
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // 텍스트필드 포커스
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(microseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // 화면 진입 시 스크롤 밑으로
    Future.delayed(
      const Duration(microseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(
        seconds: 1,
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  // 메세지 보내기
  void sendMessage() async {
    // 텍스트필드에 값이 존재할때만 보내기
    if (_messageController.text.isNotEmpty) {
      // 메세지 보내기
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      // 텍스트필드 값 초기화
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          // 채팅목록
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // 메세지 리스트
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMesages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // 에러
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // 로딩
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        // 리스트
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // 메세지 아이템
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // 로그인 사용자인지 체크
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // 메세지의 정렬
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
    );
  }

  // 메세지 input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          // 채팅 입력 input
          Expanded(
            child: MyTextfield(
              hindText: "Type a message",
              obscureText: false,
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          // send 버튼
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(
              right: 25,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
