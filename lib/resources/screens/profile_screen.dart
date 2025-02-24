import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/controllers/auth_controller.dart';
import 'package:vocary/app/signals/auth_signal.dart';
import 'package:vocary/resources/widgets/theme_toggle_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showSignOutConfirmation() {
      showShadDialog(
        context: context,
        builder:
            (context) => ShadDialog.alert(
              title: const Text('Vocary'),
              description: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Are you sure you want to sign out?'),
              ),
              gap: 20,
              actions: [
                ShadButton.outline(
                  width: double.infinity,
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(height: 4),
                ShadButton(
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    AuthController.onTapSignOut();
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          ShadTheme.of(context).colorScheme.primary,
                      child: Icon(
                        LucideIcons.user,
                        size: 50,
                        color:
                            ShadTheme.of(context).colorScheme.primaryForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'john.doe@example.com',
                      style: ShadTheme.of(context).textTheme.muted,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Menu Items Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: ShadTheme.of(context).colorScheme.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        context: context,
                        icon: LucideIcons.bell,
                        title: 'Notifications',
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1),
                      ),
                      _buildSettingItem(
                        context: context,
                        icon: LucideIcons.languages,
                        title: 'Language',
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1),
                      ),
                      _buildSettingItem(
                        context: context,
                        icon: LucideIcons.circleHelp,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1),
                      ),
                      _buildSettingItem(
                        context: context,
                        icon: LucideIcons.info,
                        title: 'About',
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(height: 1),
                      ),
                      _buildSettingItem(
                        context: context,
                        icon: LucideIcons.moon,
                        title: 'Dark Mode',
                        trailing: const ThemeToggleWidget(),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sign Out Button
              Watch((context) {
                final isSigningOut = AuthSignals.isSigningOut.value;

                return TextButton(
                  onPressed: isSigningOut ? null : showSignOutConfirmation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSigningOut)
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 8),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                      Text(
                        isSigningOut ? 'Signing out...' : 'Sign out',
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 14,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ShadTheme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
      ),
      trailing: trailing ?? Icon(LucideIcons.chevronRight, size: 18),
      onTap: onTap,
    );
  }
}
