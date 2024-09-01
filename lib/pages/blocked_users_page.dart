import 'package:chap_app_masterclass/components/user_tile.dart';
import 'package:chap_app_masterclass/services/auth/auth_service.dart';
import 'package:chap_app_masterclass/services/chat/chat_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  // 채팅 인증 서비스 갖고오기
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // 차단해제 박스
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unblock User'),
        content: const Text('차단을 해제하시겠습니까?'),
        actions: [
          // 취소버튼
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          // 해제버튼
          TextButton(
            onPressed: () {
              _chatService.unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('차단이 해제되었습니다.'),
                ),
              );
            },
            child: const Text('해제'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 현재 사용자
    String userId = _authService.getCurrentUser()!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
        actions: const [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading...'),
            );
          }
          // loading..
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data ?? []; // ?? 은 null 일 경우 빈배열을 반환

          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text('No blocked users'),
            );
          }
          // load complete
          return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];
                return UserTile(
                  text: user['email'],
                  onTap: () => _showUnblockBox(context, user['uid']),
                );
              });
        },
      ),
    );
  }
}
