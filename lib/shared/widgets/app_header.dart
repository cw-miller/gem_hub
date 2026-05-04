import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_market/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';

// Import your auth provider path here
// import 'package:job_market/features/auth/providers/auth_provider.dart'; 

class AppHeader extends ConsumerStatefulWidget {
  const AppHeader({super.key});

  @override
  ConsumerState<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends ConsumerState<AppHeader> {
  // We no longer need _isLoggedIn or _userName as local state
  // because we will read them directly from the provider.

  void _showLogoutDialog(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: isDark ? Colors.grey[300] : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () async {
              // Call your logout logic from the ViewModel
              await ref.read(authViewModelProvider.notifier).logout();
              if (ctx.mounted) {
                Navigator.pop(ctx);
              }
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state. This widget will now rebuild automatically 
    // whenever the user logs in or out.
    final authState = ref.watch(authViewModelProvider);
    final user = authState.value;
    final bool isLoggedIn = user != null;
    final String userName = 'Test'; // Adjust based on your User model fields

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSpacing = screenWidth < 360 ? 4.0 : 8.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: isLoggedIn
                ? const NetworkImage('https://i.pravatar.cc/150?img=32')
                : null,
            backgroundColor:
                isDark ? const Color(0xFF374151) : Colors.grey[300],
            child: !isLoggedIn
                ? const Icon(Icons.person, color: Colors.grey, size: 20)
                : null,
          ),
          const SizedBox(width: 10),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn
                      ? 'Welcome Back${userName.isNotEmpty ? ', $userName' : ''}!'
                      : 'Welcome, Guest',
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Find your next gem career',
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 11 : 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Action icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoggedIn) ...[
                _iconButton(
                  Icons.inbox_outlined,
                  () {},
                  isDark,
                  iconColor: const Color(0xFF3B82F6),
                ),
                SizedBox(width: iconSpacing),
                _iconButton(
                  Icons.notifications_none,
                  () {},
                  isDark,
                ),
                SizedBox(width: iconSpacing),
              ],
              _iconButton(
                isLoggedIn ? Icons.logout : Icons.login,
                () {
                  if (isLoggedIn) {
                    _showLogoutDialog(context);
                  } else {
                    context.go('/login');
                  }
                },
                isDark,
                iconColor: isLoggedIn
                    ? const Color(0xFFEF4444).withOpacity(0.9)
                    : const Color(0xFF10C971),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    VoidCallback onTap,
    bool isDark, {
    Color? iconColor,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: iconColor ?? (isDark ? Colors.white : Colors.grey[800]),
          size: 20,
        ),
        onPressed: onTap,
        splashRadius: 18,
      ),
    );
  }
}