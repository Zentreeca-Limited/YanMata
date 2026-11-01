import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yanmata/core/legal_webview_sheet.dart';
import 'package:yanmata/core/localization/language_picker_sheet.dart';
import 'package:yanmata/core/localization/locale_provider.dart';
import 'package:yanmata/core/theme.dart';
import 'package:yanmata/core/ui_feedback.dart';
import 'package:yanmata/features/account/application/account_provider.dart';
import 'package:yanmata/features/account/presentation/complete_profile_page.dart';
import 'package:yanmata/features/journal/application/journal_controller.dart';
import 'package:yanmata/features/shell.dart';

/// Screen 1 of Account Flow: Create Account / Sign In
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key, this.isSignUp = true, this.onComplete});

  final bool isSignUp;
  final VoidCallback? onComplete;

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  late bool _isSignUp;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _selectedDob;
  bool _acceptTerms = false;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUp;
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        if (!mounted) return;
        LegalWebViewSheet.showTerms(
          context,
          title: ref.tr('auth_terms_link'),
        );
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        if (!mounted) return;
        LegalWebViewSheet.showPrivacy(
          context,
          title: ref.tr('auth_privacy_link'),
        );
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    // Must be at least 9 years old
    final latestEligible = DateTime(now.year - 9, now.month, now.day);
    final initialDate =
        _selectedDob ?? DateTime(now.year - 20, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(latestEligible)
          ? latestEligible
          : initialDate,
      firstDate: DateTime(1920),
      lastDate: latestEligible,
      helpText: 'Select your date of birth (ages 9+)',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Palette.plum,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDob = picked);
    }
  }

  String _formatDob(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isSignUp) {
      if (_selectedDob == null) {
        YanMataFeedback.showErrorSnackbar(context, ref.tr('auth_err_dob'));
        return;
      }
      if (!_acceptTerms) {
        YanMataFeedback.showErrorSnackbar(context, ref.tr('auth_err_terms'));
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      if (_isSignUp) {
        await ref
            .read(journalProvider.notifier)
            .register(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              dateOfBirth: _formatDob(_selectedDob!),
            );
      } else {
        await ref
            .read(journalProvider.notifier)
            .connect(_emailController.text.trim(), _passwordController.text);
      }

      // Check profile state
      final profile = await ref
          .read(accountRepositoryProvider)
          .fetchProfile(token: ref.read(journalProvider).value?.token);

      if (!mounted) return;

      if (!profile.completed) {
        // Step 2: Complete Profile
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => CompleteProfilePage(onComplete: widget.onComplete),
          ),
        );
      } else {
        await _finishToHome();
      }
    } catch (e) {
      if (mounted) {
        YanMataFeedback.showErrorSnackbar(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _finishToHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
    } catch (_) {}
    if (!mounted) return;
    widget.onComplete?.call();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const YanMataShell()),
      (route) => false,
    );
  }

  void _showForgotPasswordSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = isDark ? Palette.darkText : Palette.ink;
    final muted = isDark ? Palette.darkMuted : Palette.slate;
    final accent = Theme.of(context).colorScheme.primary;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? Palette.darkSurface : Palette.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_reset_outlined, color: accent, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ref.tr('auth_forgot_password'),
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 20, color: muted),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Because YanMata keeps your health journal private on your device by default, you can continue using YanMata offline or contact yanmata@zentreeca.org from your registered email address for account recovery assistance.',
              style: TextStyle(fontSize: 13.5, height: 1.55, color: muted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(ref.tr('understood')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;
    final text = isDark ? Palette.darkText : Palette.ink;
    final muted = isDark ? Palette.darkMuted : Palette.slate;
    final cardBg = isDark ? Palette.darkCard : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSignUp ? ref.tr('auth_create_title') : ref.tr('auth_login_title'),
          style: const TextStyle(
            fontFamily: 'Fraunces',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: 'Language',
            onPressed: () => LanguagePickerSheet.show(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isSignUp
                          ? ref.tr('auth_create_sub')
                          : ref.tr('auth_login_sub'),
                      style: TextStyle(fontSize: 14, color: muted, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // Toggle Tabs between Sign Up and Sign In
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Palette.darkSurface : Palette.blush,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isSignUp = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _isSignUp
                                      ? cardBg
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _isSignUp
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.06,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  ref.tr('auth_create_title'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: _isSignUp
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: _isSignUp ? accent : muted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isSignUp = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isSignUp
                                      ? cardBg
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: !_isSignUp
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.06,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  ref.tr('auth_submit_login'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: !_isSignUp
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: !_isSignUp ? accent : muted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Full Name (Only on Sign Up)
                    if (_isSignUp) ...[
                      Text(
                        ref.tr('auth_name_label'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: ref.tr('auth_name_hint'),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            size: 20,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().length < 2) {
                            return ref.tr('auth_err_name');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email
                    Text(
                      ref.tr('auth_email_label'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: ref.tr('auth_email_hint'),
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || !v.contains('@') || !v.contains('.')) {
                          return ref.tr('auth_err_email');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Text(
                      ref.tr('auth_password_label'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: ref.tr('auth_password_hint'),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.length < 8) {
                          return ref.tr('auth_err_password');
                        }
                        return null;
                      },
                    ),
                    if (!_isSignUp) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: _showForgotPasswordSheet,
                          child: Text(
                            ref.tr('auth_forgot_password'),
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                              color: muted,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Date of Birth (Only on Sign Up)
                    if (_isSignUp) ...[
                      Text(
                        ref.tr('auth_dob_label'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDob,
                        borderRadius: BorderRadius.circular(16),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            hintText: ref.tr('auth_dob_hint'),
                            prefixIcon: const Icon(
                              Icons.cake_outlined,
                              size: 20,
                            ),
                            suffixIcon: const Icon(
                              Icons.calendar_month,
                              size: 20,
                            ),
                          ),
                          child: Text(
                            _selectedDob != null
                                ? _formatDob(_selectedDob!)
                                : 'Select Date of Birth',
                            style: TextStyle(
                              color: _selectedDob != null ? text : muted,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Terms & Minor safeguarding notice
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: accent,
                            onChanged: (v) =>
                                setState(() => _acceptTerms = v ?? false),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 12.5,
                                    color: text,
                                    height: 1.45,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ref.tr('auth_terms_prefix'),
                                    ),
                                    TextSpan(
                                      text: ref.tr('auth_terms_link'),
                                      recognizer: _termsRecognizer,
                                      style: TextStyle(
                                        color: accent,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: accent,
                                      ),
                                    ),
                                    TextSpan(text: ref.tr('auth_terms_and')),
                                    TextSpan(
                                      text: ref.tr('auth_privacy_link'),
                                      recognizer: _privacyRecognizer,
                                      style: TextStyle(
                                        color: accent,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Palette.darkSurface
                              : Palette.blush.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 16,
                              color: accent,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ref.tr('auth_age_notice'),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: muted,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isSignUp
                                    ? ref.tr('auth_submit_register')
                                    : ref.tr('auth_submit_login'),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skip as Guest
                    Center(
                      child: TextButton(
                        onPressed: _finishToHome,
                        child: Text(
                          ref.tr('auth_skip_guest'),
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
