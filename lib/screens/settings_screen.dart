import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/theme_provider.dart';
import '../providers/journal_provider.dart';
import '../providers/chat_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(context),
            const SizedBox(height: 24),
            
            // Appearance Section
            _buildAppearanceSection(context, ref, themeMode),
            const SizedBox(height: 24),
            
            // Data Section
            _buildDataSection(context, ref),
            const SizedBox(height: 24),
            
            // Support Section
            _buildSupportSection(context),
            const SizedBox(height: 24),
            
            // About Section
            _buildAboutSection(context),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.person,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anonymous User',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your privacy is protected',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    return _buildSection(
      context,
      'Appearance',
      [
        _buildSettingsTile(
          context,
          Icons.palette_outlined,
          'Theme',
          _getThemeDescription(themeMode),
          onTap: () => _showThemeDialog(context, ref, themeMode),
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context, WidgetRef ref) {
    return _buildSection(
      context,
      'Data & Privacy',
      [
        _buildSettingsTile(
          context,
          Icons.download_outlined,
          'Export Data',
          'Download your journal entries',
          onTap: () => _showExportDialog(context),
        ),
        _buildSettingsTile(
          context,
          Icons.delete_outline,
          'Clear All Data',
          'Remove all stored information',
          onTap: () => _showClearDataDialog(context, ref),
          textColor: AppTheme.errorColor,
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSection(
      context,
      'Support & Help',
      [
        _buildSettingsTile(
          context,
          Icons.help_outline,
          'Help Center',
          'Get answers to common questions',
          onTap: () => _showHelpDialog(context),
        ),
        _buildSettingsTile(
          context,
          Icons.feedback_outlined,
          'Send Feedback',
          'Help us improve the app',
          onTap: () => _showFeedbackDialog(context),
        ),
        _buildSettingsTile(
          context,
          Icons.phone_outlined,
          'Crisis Resources',
          'Emergency contacts and hotlines',
          onTap: () => _showCrisisResourcesDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context,
      'About',
      [
        _buildSettingsTile(
          context,
          Icons.info_outline,
          'App Version',
          StorageService.instance.getAppVersion(),
        ),
        _buildSettingsTile(
          context,
          Icons.description_outlined,
          'Privacy Policy',
          'How we protect your data',
          onTap: () => _showPrivacyPolicyDialog(context),
        ),
        _buildSettingsTile(
          context,
          Icons.gavel_outlined,
          'Terms of Service',
          'App usage terms and conditions',
          onTap: () => _showTermsDialog(context),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.2);
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[600],
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            )
          : null,
      onTap: onTap,
    );
  }

  String _getThemeDescription(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'Follow system';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeMode currentTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Follow System'),
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your journal entries will be exported as a JSON file. This feature helps you backup your data or transfer it to another device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export feature coming soon!'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your journal entries and chat room data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await StorageService.instance.clearAllData();
              // Refresh providers
              ref.invalidate(journalEntriesProvider);
              ref.invalidate(chatRoomsProvider);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text(
              'Clear Data',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Frequently Asked Questions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('Q: How do I add a journal entry?'),
              Text('A: Tap the + button on the dashboard or go to the Journal tab.'),
              SizedBox(height: 8),
              Text('Q: Are my conversations private?'),
              Text('A: Yes, all chat rooms are anonymous and secure.'),
              SizedBox(height: 8),
              Text('Q: How do I change the app theme?'),
              Text('A: Go to Settings > Appearance > Theme.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Tell us what you think about the app...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showCrisisResourcesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crisis Resources'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'If you\'re in crisis, please reach out:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('🆘 Emergency Services: 911'),
              SizedBox(height: 8),
              Text('📞 Crisis Text Line: Text HOME to 741741'),
              SizedBox(height: 8),
              Text('☎️ National Suicide Prevention Lifeline: 988'),
              SizedBox(height: 8),
              Text('🏥 Campus Counseling: (555) 123-4567'),
              SizedBox(height: 16),
              Text(
                'Remember: You are not alone. Help is available 24/7.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Airen is committed to protecting your privacy. All data is stored locally on your device and is never transmitted to external servers without your explicit consent.\n\n'
            'We collect minimal data necessary for app functionality:\n'
            '• Journal entries (stored locally)\n'
            '• App preferences (stored locally)\n'
            '• Anonymous usage analytics (optional)\n\n'
            'Your mental health data is sensitive and we treat it with the highest level of security and confidentiality.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using Airen, you agree to these terms:\n\n'
            '1. This app is for educational and wellness purposes only\n'
            '2. It is not a substitute for professional medical advice\n'
            '3. In case of emergency, contact emergency services immediately\n'
            '4. Use respectful language in chat rooms\n'
            '5. Report inappropriate behavior\n'
            '6. We reserve the right to moderate content\n\n'
            'These terms may be updated periodically. Continued use constitutes acceptance of any changes.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
