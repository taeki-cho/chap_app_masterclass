import 'package:chap_app_masterclass/components/my_drawer.dart';
import 'package:chap_app_masterclass/components/user_tile.dart';
import 'package:chap_app_masterclass/pages/chat_page.dart';
import 'package:chap_app_masterclass/services/auth/auth_service.dart';
import 'package:chap_app_masterclass/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // 채팅 & 인증 서비스
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // 현재 로그인한 사용자의 목록
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        // 에러
        if (!snapshot.hasData) {
          return const Text("error");
        }
        // 로딩
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // 리스트목록 리턴
        return ListView(
          children: snapshot.data!
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
