import 'package:chap_app_masterclass/services/chat/chat_service.dart';
import 'package:chap_app_masterclass/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  // 옵션 보여주기
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(context);
                    _reportMessage(context, messageId, userId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Block User'),
                  onTap: () {
                    Navigator.pop(context);
                    _userBlock(context, userId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Message'),
        content: const Text('메세지를 보고하시겠습니까?'),
        actions: [
          // 취소버튼
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          // 보고버튼
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('메세지가 보고 되었습니다.'),
                ),
              );
            },
            child: const Text('보고'),
          ),
        ],
      ),
    );
  }

  // 사용자 차단
  void _userBlock(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('사용자를 차단하시겠습니까?'),
        actions: [
          // 취소버튼
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          // 차단 버튼
          TextButton(
            onPressed: () {
              // 차단처리
              ChatService().blockUser(userId);
              // 팝업닫고
              Navigator.pop(context);
              // 채팅창에서도 나가기
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('사용자가 차단되었습니다.'),
                ),
              );
            },
            child: const Text('차단'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // light vs dark 모드 컬러
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // 내가 아닌 사용자면 옵션 보여주기
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(
          vertical: 2.5,
          horizontal: 25,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
