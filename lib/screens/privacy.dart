import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../widgets/main_navigation_bar.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  // Saved switches
  bool analytics = true;
  bool crashReports = true;
  bool ads = false;
  bool publicProfile = false;
  bool shareProgress = false;
  bool twoFactor = false;

  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  // Load actual values if stored in SharedPreferences
  Future<void> _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      analytics = prefs.getBool('analytics') ?? true;
      crashReports = prefs.getBool('crashReports') ?? true;
      ads = prefs.getBool('ads') ?? false;
      publicProfile = prefs.getBool('publicProfile') ?? false;
      shareProgress = prefs.getBool('shareProgress') ?? false;
      twoFactor = prefs.getBool('twoFactor') ?? false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Fetch all user profile and habits, export beautifully in JSON format
  Future<void> _downloadMyData() async {
    setState(() => _isExporting = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No authenticated user found.')),
        );
        return;
      }
      
      final uid = user.uid;

      // 1. Fetch profile document
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final profileData = doc.data() ?? {};
      
      // 2. Fetch habits sub-collection
      final habitsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('habits')
          .get();
      
      final habitsList = habitsSnapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
      
      // 3. Combine into structured compliance export model
      final exportData = {
        'app': 'HabitFlow',
        'exported_at': DateTime.now().toIso8601String(),
        'user_id': uid,
        'profile': profileData,
        'habits': habitsList,
      };
      
      // Format JSON beautifully
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      
      // Write to a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/habitflow_my_data_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);
      
      // Share file via share_plus
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json')],
        text: 'Here is your HabitFlow account data export.',
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully! 📂'),
          backgroundColor: Color(0xFF16C9E6),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void _showChangePasswordDialog() async {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user?.isAnonymous ?? true;

    if (isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Guest profiles do not have a password. Link your account to set a password!"),
          backgroundColor: Color(0xFF16C9E6),
        ),
      );
      return;
    }

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _ChangePasswordDialog(),
    );

    if (success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully! 🔐"),
          backgroundColor: Color(0xFF16C9E6),
        ),
      );
    }
  }

  void _showDeleteAccountDialog() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    final isGuest = user.isAnonymous;

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeleteAccountDialog(isGuest: isGuest),
    );

    if (success == true) {
      // Wiped successfully! Redirect to auth page and clear nav stack.
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: const Color(0xFF16C9E6),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text("Manage your data and security settings", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 18),
              const _SectionTitle(label: "Data Privacy", icon: Icons.data_usage),
              _SettingsSwitchTile(
                label: "Analytics",
                subtitle: "Help improve the app with usage data",
                value: analytics,
                onChanged: (val) {
                  setState(() => analytics = val);
                  _saveSetting('analytics', val);
                },
              ),
              _SettingsSwitchTile(
                label: "Crash Reports",
                subtitle: "Send crash reports to help fix bugs",
                value: crashReports,
                onChanged: (val) {
                  setState(() => crashReports = val);
                  _saveSetting('crashReports', val);
                },
              ),
              _SettingsSwitchTile(
                label: "Personalized Ads",
                subtitle: "Show ads based on your interests",
                value: ads,
                onChanged: (val) {
                  setState(() => ads = val);
                  _saveSetting('ads', val);
                },
              ),
              const SizedBox(height: 20),
              const _SectionTitle(label: "Sharing", icon: Icons.share),
              _SettingsSwitchTile(
                label: "Public Profile",
                subtitle: "Make your profile visible to others",
                value: publicProfile,
                onChanged: (val) {
                  setState(() => publicProfile = val);
                  _saveSetting('publicProfile', val);
                },
              ),
              _SettingsSwitchTile(
                label: "Share Progress",
                subtitle: "Allow others to see your habit progress",
                value: shareProgress,
                onChanged: (val) {
                  setState(() => shareProgress = val);
                  _saveSetting('shareProgress', val);
                },
              ),
              const SizedBox(height: 20),
              const _SectionTitle(label: "Security", icon: Icons.lock),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: const Icon(Icons.password, color: Color(0xFF16C9E6)),
                  title: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Update your account password"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onTap: _showChangePasswordDialog,
                )
              ),
              _SettingsSwitchTile(
                label: "Two-Factor Authentication",
                subtitle: "Add extra security to your account",
                value: twoFactor,
                onChanged: (val) {
                  setState(() => twoFactor = val);
                  _saveSetting('twoFactor', val);
                },
              ),
              const SizedBox(height: 20),
              const _SectionTitle(label: "Data Management", icon: Icons.remove_red_eye),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: _isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Color(0xFF16C9E6), strokeWidth: 2),
                        )
                      : const Icon(Icons.download, color: Color(0xFF16C9E6)),
                  title: const Text("Download My Data", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Get a local JSON export of all your routines and logs"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onTap: _isExporting ? null : _downloadMyData,
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text("Delete All Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  subtitle: const Text("Irreversibly wipe habits, streaks, and delete your profile"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                  onTap: _showDeleteAccountDialog,
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text("Privacy Policy", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text("Terms of Service", style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          String route = '';
          switch (index) {
            case 0: route = '/dashboard'; break;
            case 1: route = '/habits'; break;
            case 2: route = '/profile'; break;
            case 3: route = '/more'; break;
          }
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        },
      ),
    );
  }
}

// --- Stateful Change Password Dialog ---
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      setState(() => _errorMessage = "Passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        
        Navigator.pop(context, true); // Success
      } else {
        setState(() => _errorMessage = "User not found or has no email.");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          _errorMessage = "Current password is incorrect.";
        } else if (e.code == 'weak-password') {
          _errorMessage = "Password is too weak. Must be at least 6 characters.";
        } else {
          _errorMessage = e.message ?? "An error occurred.";
        }
      });
    } catch (e) {
      setState(() => _errorMessage = "Failed to update password: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  prefixIcon: const Icon(Icons.lock_open, color: Color(0xFF16C9E6)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                    onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF16C9E6)),
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF16C9E6)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF16C9E6)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Required";
                  if (val.length < 6) return "Must be at least 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF16C9E6)),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF16C9E6)),
                  ),
                ),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16C9E6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text("Update Password"),
        ),
      ],
    );
  }
}

// --- Stateful Delete Account Dialog ---
class _DeleteAccountDialog extends StatefulWidget {
  final bool isGuest;
  const _DeleteAccountDialog({required this.isGuest});

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!widget.isGuest && !_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;

        // If email-registered, re-authenticate first
        if (!widget.isGuest) {
          final password = _passwordController.text.trim();
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );
          await user.reauthenticateWithCredential(credential);
        }

        // 1. Delete habits sub-collection
        final habitsQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('habits')
            .get();
        final batch = FirebaseFirestore.instance.batch();
        for (var doc in habitsQuery.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();

        // 2. Delete user profile doc
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();

        // 3. Clear SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // 4. Cancel notifications
        await NotificationService().cancelAll();

        // 5. Delete Firebase Auth account
        await user.delete();

        Navigator.pop(context, true); // Success
      } else {
        setState(() => _errorMessage = "No authenticated user found.");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          _errorMessage = "Incorrect password. Authentication failed.";
        } else {
          _errorMessage = e.message ?? "An error occurred during deletion.";
        }
      });
    } catch (e) {
      setState(() => _errorMessage = "Failed to purge account data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Delete All Data & Account",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "This action is absolutely IRREVERSIBLE. All habits, streaks, completions, and user profile data will be permanently wiped.",
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 12),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (!widget.isGuest) ...[
                const Text(
                  "To confirm, please enter your password:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.red),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (val) => val == null || val.isEmpty ? "Required" : null,
                ),
              ] else ...[
                const Text(
                  "Since you are in Guest Mode, confirming will immediately wipe all local/remote data and reset the app.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text("DELETE PERMANENTLY", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// --- Helper widgets ---
class _SectionTitle extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionTitle({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF16C9E6)),
        const SizedBox(width: 7),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      ],
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitchTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF16C9E6),
      ),
    );
  }
}
