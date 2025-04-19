import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  double _searchRadius = 25.0;
  RangeValues _ageRange = const RangeValues(18, 35);
  String _selectedLanguage = 'English';
  bool _darkModeEnabled = false;
  bool _showOnlineStatus = true;
  String _selectedTheme = 'System Default';
  final List<String> _themes = ['System Default', 'Light', 'Dark', 'Auto'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _locationEnabled = prefs.getBool('location') ?? true;
      _searchRadius = prefs.getDouble('searchRadius') ?? 25.0;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      _showOnlineStatus = prefs.getBool('showOnline') ?? true;
      _selectedTheme = prefs.getString('theme') ?? 'System Default';
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('location', _locationEnabled);
    await prefs.setDouble('searchRadius', _searchRadius);
    await prefs.setBool('darkMode', _darkModeEnabled);
    await prefs.setBool('showOnline', _showOnlineStatus);
    await prefs.setString('theme', _selectedTheme);
    await prefs.setString('language', _selectedLanguage);
  }

  Future<void> _clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to clear cache'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual logout logic with your auth service
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement actual account deletion logic
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._themes.map((theme) => ListTile(
                    onTap: () {
                      setState(() => _selectedTheme = theme);
                      _saveSettings();
                      Navigator.pop(context);
                    },
                    title: Text(theme),
                    trailing: theme == _selectedTheme
                        ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                          )
                        : null,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch URL'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.primaryColor;
            }
            return Colors.grey;
          }),
          trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return AppTheme.primaryColor.withOpacity(0.5);
            }
            return Colors.grey.withOpacity(0.3);
          }),
        ),
      ),
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildAnimatedSection(
                  title: 'Account',
                  icon: Icons.person_outline,
                  delay: 0,
                  children: [
                    _buildRippleCard(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      subtitle: 'Manage your privacy settings',
                      onTap: () {
                        // TODO: Navigate to privacy settings
                      },
                    ),
                    _buildRippleCard(
                      icon: Icons.security_outlined,
                      title: 'Security',
                      subtitle: 'Protect your account',
                      onTap: () {
                        // TODO: Navigate to security settings
                      },
                    ),
                  ],
                ),
                _buildAnimatedSection(
                  title: 'Preferences',
                  icon: Icons.tune,
                  delay: 1,
                  children: [
                    _buildSettingsCard(
                      child: Column(
                        children: [
                          _buildCustomSwitch(
                            title: 'Push Notifications',
                            subtitle: 'Receive match and message alerts',
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() => _notificationsEnabled = value);
                            },
                          ),
                          const Divider(),
                          _buildCustomSwitch(
                            title: 'Location Services',
                            subtitle: 'Show people near you',
                            value: _locationEnabled,
                            onChanged: (value) {
                              setState(() => _locationEnabled = value);
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildSettingsCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Search Radius',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_searchRadius.round()} km',
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.primaryColor,
                              inactiveTrackColor: Colors.grey[200],
                              thumbColor: AppTheme.primaryColor,
                              overlayColor: AppTheme.primaryColor.withOpacity(0.1),
                              valueIndicatorColor: AppTheme.primaryColor,
                            ),
                            child: Slider(
                              value: _searchRadius,
                              min: 1,
                              max: 100,
                              divisions: 99,
                              label: '${_searchRadius.round()} km',
                              onChanged: (value) {
                                setState(() => _searchRadius = value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSettingsCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Age Range',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_ageRange.start.round()} - ${_ageRange.end.round()} years',
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.primaryColor,
                              inactiveTrackColor: Colors.grey[200],
                              thumbColor: AppTheme.primaryColor,
                              overlayColor: AppTheme.primaryColor.withOpacity(0.1),
                              valueIndicatorColor: AppTheme.primaryColor,
                            ),
                            child: RangeSlider(
                              values: _ageRange,
                              min: 18,
                              max: 100,
                              divisions: 82,
                              labels: RangeLabels(
                                '${_ageRange.start.round()}',
                                '${_ageRange.end.round()}',
                              ),
                              onChanged: (values) {
                                setState(() => _ageRange = values);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildAnimatedSection(
                  title: 'Appearance',
                  icon: Icons.palette_outlined,
                  delay: 1,
                  children: [
                    _buildSettingsCard(
                      child: Column(
                        children: [
                          _buildCustomSwitch(
                            title: 'Dark Mode',
                            subtitle: 'Enable dark theme',
                            value: _darkModeEnabled,
                            onChanged: (value) {
                              setState(() => _darkModeEnabled = value);
                              _saveSettings();
                            },
                          ),
                          const Divider(),
                          _buildRippleCard(
                            icon: Icons.color_lens_outlined,
                            title: 'Theme',
                            subtitle: _selectedTheme,
                            onTap: _showThemeDialog,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildAnimatedSection(
                  title: 'Privacy',
                  icon: Icons.privacy_tip_outlined,
                  delay: 2,
                  children: [
                    _buildSettingsCard(
                      child: _buildCustomSwitch(
                        title: 'Online Status',
                        subtitle: 'Show when you\'re active',
                        value: _showOnlineStatus,
                        onChanged: (value) {
                          setState(() => _showOnlineStatus = value);
                          _saveSettings();
                        },
                      ),
                    ),
                  ],
                ),
                _buildAnimatedSection(
                  title: 'App Settings',
                  icon: Icons.settings_outlined,
                  delay: 3,
                  children: [
                    _buildRippleCard(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: _selectedLanguage,
                      onTap: _showLanguageDialog,
                    ),
                    _buildRippleCard(
                      icon: Icons.cleaning_services_outlined,
                      title: 'Clear Cache',
                      subtitle: 'Free up space',
                      onTap: _clearCache,
                    ),
                  ],
                ),
                _buildAnimatedSection(
                  title: 'Support & Legal',
                  icon: Icons.help_outline,
                  delay: 4,
                  children: [
                    _buildRippleCard(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      subtitle: 'Get help with your account',
                      onTap: () => _launchURL('https://yourdatingapp.com/help'),
                    ),
                    _buildRippleCard(
                      icon: Icons.policy_outlined,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms',
                      onTap: () => _launchURL('https://yourdatingapp.com/terms'),
                    ),
                    _buildRippleCard(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () => _launchURL('https://yourdatingapp.com/privacy'),
                    ),
                  ],
                ),
                _buildAnimatedSection(
                  title: 'Account Actions',
                  icon: Icons.manage_accounts_outlined,
                  delay: 5,
                  children: [
                    _buildDangerButton(
                      icon: Icons.logout,
                      title: 'Log Out',
                      color: Colors.orange,
                      onTap: _showLogoutDialog,
                    ),
                    _buildDangerButton(
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      color: Colors.red,
                      onTap: _showDeleteAccountDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({
    required String title,
    required IconData icon,
    required int delay,
    required List<Widget> children,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            delay * 0.1,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay * 0.1,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRippleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _buildSettingsCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDangerButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _buildSettingsCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...languages.map((language) => ListTile(
                    onTap: () {
                      setState(() => _selectedLanguage = language);
                      Navigator.pop(context);
                    },
                    title: Text(language),
                    trailing: language == _selectedLanguage
                        ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                          )
                        : null,
                  )),
            ],
          ),
        ),
      ),
    );
  }
} 