import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Toggle states
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _downloadOverWifi = true;
  bool _highQualityStreaming = false;
  bool _dataSaver = false;

  // Language selection
  String _selectedLanguage = 'English';
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Korean'
  ];

  // Audio quality
  String _selectedAudioQuality = 'Normal';
  final List<String> _audioQualities = ['Low', 'Normal', 'High', 'Very High'];

  // Primary color
  final Color primaryColor = const Color(0xFF8b2cf5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Standardized App Bar with consistent height and padding
            Container(
              color: Colors.white,
              height: 60, // Fixed height for consistency
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8b2cf5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider for visual separation
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),

            // Main Content - Settings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Account Section
                  _buildSectionHeader('Account'),
                  _buildSettingItem(
                    icon: Icons.person,
                    title: 'Profile Information',
                    subtitle: 'Change your profile details',
                    onTap: () {
                      _showComingSoonSnackBar();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: false,
                  ),
                  _buildSettingItem(
                    icon: Icons.lock,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      _showComingSoonSnackBar();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: false,
                  ),
                  _buildSettingItem(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: _selectedLanguage,
                    onTap: () {
                      _showLanguageSelectionDialog();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: true, // Use primary color for this item
                  ),

                  const SizedBox(height: 24),

                  // Notifications Section
                  _buildSectionHeader('Notifications'),
                  _buildSwitchSettingItem(
                    icon: Icons.notifications,
                    title: 'Push Notifications',
                    subtitle:
                        'Receive notifications about new songs and updates',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      HapticFeedback.lightImpact();
                    },
                    useAccentColor: false,
                  ),

                  const SizedBox(height: 24),

                  // Appearance Section
                  _buildSectionHeader('Appearance'),
                  _buildSwitchSettingItem(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: 'Switch between light and dark theme',
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                      HapticFeedback.lightImpact();
                      _showComingSoonSnackBar(
                          'Dark mode will be available soon');
                    },
                    useAccentColor: true, // Use primary color for this item
                  ),

                  const SizedBox(height: 24),

                  // Playback & Download Section
                  _buildSectionHeader('Playback & Download'),
                  _buildSettingItem(
                    icon: Icons.music_note,
                    title: 'Audio Quality',
                    subtitle: 'Streaming: $_selectedAudioQuality',
                    onTap: () {
                      _showAudioQualitySelectionDialog();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: true, // Use primary color for this item
                  ),
                  _buildSwitchSettingItem(
                    icon: Icons.wifi,
                    title: 'Download Over Wi-Fi Only',
                    subtitle: 'Save mobile data by downloading over Wi-Fi',
                    value: _downloadOverWifi,
                    onChanged: (value) {
                      setState(() {
                        _downloadOverWifi = value;
                      });
                      HapticFeedback.lightImpact();
                    },
                    useAccentColor: false,
                  ),
                  _buildSwitchSettingItem(
                    icon: Icons.high_quality,
                    title: 'High Quality Streaming',
                    subtitle: 'Stream music in higher quality',
                    value: _highQualityStreaming,
                    onChanged: (value) {
                      setState(() {
                        _highQualityStreaming = value;
                      });
                      HapticFeedback.lightImpact();
                    },
                    useAccentColor: false,
                  ),
                  _buildSwitchSettingItem(
                    icon: Icons.data_saver_off,
                    title: 'Data Saver',
                    subtitle: 'Reduce data usage while streaming',
                    value: _dataSaver,
                    onChanged: (value) {
                      setState(() {
                        _dataSaver = value;
                        if (value) {
                          _highQualityStreaming = false;
                        }
                      });
                      HapticFeedback.lightImpact();
                    },
                    useAccentColor: true, // Use primary color for this item
                  ),

                  const SizedBox(height: 24),

                  // About Section
                  _buildSectionHeader('About'),
                  _buildSettingItem(
                    icon: Icons.info,
                    title: 'About Singify',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      _showAboutDialog();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: true, // Use primary color for this item
                  ),
                  _buildSettingItem(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () {
                      _showComingSoonSnackBar();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: false,
                  ),
                  _buildSettingItem(
                    icon: Icons.description,
                    title: 'Terms of Service',
                    subtitle: 'Read our terms of service',
                    onTap: () {
                      _showComingSoonSnackBar();
                    },
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    useAccentColor: false,
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutConfirmationDialog();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333), // Dark gray for all section headers
        ),
      ),
    );
  }

  // Helper method to build setting items
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Widget trailing,
    required bool useAccentColor,
  }) {
    // Use primary color for selected items, gray for others
    final Color iconColor =
        useAccentColor ? primaryColor : const Color(0xFF666666);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: useAccentColor
                      ? primaryColor.withOpacity(0.1)
                      : const Color(
                          0xFFEEEEEE), // Light gray for non-accent items
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build switch setting items
  Widget _buildSwitchSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool useAccentColor,
  }) {
    // Use primary color for selected items, gray for others
    final Color iconColor =
        useAccentColor ? primaryColor : const Color(0xFF666666);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: useAccentColor
                  ? primaryColor.withOpacity(0.1)
                  : const Color(0xFFEEEEEE), // Light gray for non-accent items
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor:
                primaryColor, // Keep primary color for all switches for consistency
          ),
        ],
      ),
    );
  }

  // Show coming soon snackbar
  void _showComingSoonSnackBar(
      [String message = 'This feature is coming soon!']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show language selection dialog
  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                  activeColor: primaryColor,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show audio quality selection dialog
  void _showAudioQualitySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Audio Quality'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _audioQualities.length,
              itemBuilder: (context, index) {
                final quality = _audioQualities[index];
                return RadioListTile<String>(
                  title: Text(quality),
                  subtitle: Text(_getAudioQualityDescription(quality)),
                  value: quality,
                  groupValue: _selectedAudioQuality,
                  onChanged: (value) {
                    setState(() {
                      _selectedAudioQuality = value!;
                      if (value == 'High' || value == 'Very High') {
                        _highQualityStreaming = true;
                        _dataSaver = false;
                      }
                    });
                    Navigator.pop(context);
                  },
                  activeColor: primaryColor,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Get audio quality description
  String _getAudioQualityDescription(String quality) {
    switch (quality) {
      case 'Low':
        return '~96 kbps (Uses less data)';
      case 'Normal':
        return '~160 kbps (Balanced)';
      case 'High':
        return '~320 kbps (Uses more data)';
      case 'Very High':
        return '~1411 kbps (Lossless, uses most data)';
      default:
        return '';
    }
  }

  // Show about dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About Singify'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.music_note,
                size: 60,
                color: primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Singify',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Lyrics Companion',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2023 Singify Inc. All rights reserved.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showComingSoonSnackBar('Logout functionality coming soon');
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
