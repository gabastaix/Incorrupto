import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design/figma_contract.dart';
import '../../services/auth_service.dart';

// ─────────────────────────────────────────────
//  CONSTANTES DE DESIGN LOCALES
// ─────────────────────────────────────────────
class _LC {
  static const double radius = 16.0;
  static const Duration anim = Duration(milliseconds: 320);
  static const Curve curve = Curves.easeInOutCubic;

  static const List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];
}

// ─────────────────────────────────────────────
//  WIDGET PRINCIPAL
// ─────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  final ValueChanged<String> onLogin;

  // ⚡ DEV ONLY — passe false avant le release
  final bool showSkipButton;

  const LoginScreen({
    super.key,
    required this.onLogin,
    this.showSkipButton = true,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  // ── Tab : 0 = Connexion, 1 = Inscription ──
  TabController? _tabController;
  int _currentTab = 0;

  // ── Champs communs ──
  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();

  // ── Champs inscription uniquement ──
  final _firstNameCtrl  = TextEditingController();
  final _lastNameCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();

  bool      _obscurePassword = true;
  bool      _obscureConfirm  = true;
  bool      _isLoading       = false;
  String    _message         = '';
  bool      _isError         = false;
  DateTime? _birthDate;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _currentTab = _tabController!.index;
          _message    = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Connexion ──────────────────────────────
  Future<void> _login() async {
    _setLoading(true);
    try {
      final response = await _authService.login(
          _emailCtrl.text.trim(), _passwordCtrl.text);
      final token   = response['access_token'] as String;
      final profile = await _authService.getMe(token);
      final firstName   = profile['first_name'] as String? ?? '';
      final displayName = firstName.isNotEmpty
          ? firstName
          : _deriveUserName(_emailCtrl.text.trim());
      widget.onLogin(displayName);
    } catch (_) {
      _setMessage('Email ou mot de passe incorrect.', isError: true);
    } finally {
      _setLoading(false);
    }
  }

  // ── Inscription ────────────────────────────
  Future<void> _register() async {
    if (_passwordCtrl.text != _confirmCtrl.text) {
      _setMessage('Les mots de passe ne correspondent pas.', isError: true);
      return;
    }
    _setLoading(true);
    try {
      final response = await _authService.register(
        email:     _emailCtrl.text.trim(),
        password:  _passwordCtrl.text,
        firstName: _firstNameCtrl.text.trim(),
        lastName:  _lastNameCtrl.text.trim(),
      );
      final token       = response['access_token'] as String;
      final profile     = await _authService.getMe(token);
      final displayName =
          profile['first_name'] as String? ?? _firstNameCtrl.text.trim();
      widget.onLogin(displayName);
    } catch (_) {
      _setMessage('Inscription impossible. Réessaie.', isError: true);
    } finally {
      _setLoading(false);
    }
  }

  // ── Connexion sociale ──────────────────────
  Future<void> _socialLogin(String provider) async {
    _setLoading(true);
    try {
      // TODO : intègre google_sign_in / sign_in_with_apple
      await Future.delayed(const Duration(seconds: 1));
      widget.onLogin('User');
    } catch (_) {
      _setMessage('Connexion $provider impossible.', isError: true);
    } finally {
      _setLoading(false);
    }
  }

  // ── Skip (dev only) ────────────────────────
  void _skipLogin() {
    HapticFeedback.lightImpact();
    widget.onLogin('Dev User');
  }

  // ── Helpers ───────────────────────────────
  void _setLoading(bool v) => setState(() => _isLoading = v);

  void _setMessage(String msg, {bool isError = false}) =>
      setState(() {
        _message = msg;
        _isError = isError;
      });

  String _deriveUserName(String email) {
    final local   = email.split('@').first;
    final cleaned = local.replaceAll(RegExp(r'[._\-]+'), ' ').trim();
    if (cleaned.isEmpty) return '';
    final word = cleaned.split(' ').first;
    return word[0].toUpperCase() + word.substring(1);
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
Widget build(BuildContext context) {
  if (_tabController == null) {
    return const Scaffold(body: SizedBox.shrink());
  }
  return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _BackgroundDecoration(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  _Logo(),
                  const SizedBox(height: 40),
                  _TabBar(controller: _tabController!),
                  const SizedBox(height: 32),

                  // ── Formulaire animé ──
                  AnimatedSwitcher(
                    duration: _LC.anim,
                    switchInCurve: _LC.curve,
                    switchOutCurve: _LC.curve,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: _currentTab == 0
                        ? _LoginForm(
                            key: const ValueKey('login'),
                            emailCtrl: _emailCtrl,
                            passwordCtrl: _passwordCtrl,
                            obscurePassword: _obscurePassword,
                            onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            onSubmit: _login,
                            isLoading: _isLoading,
                          )
                        : _RegisterForm(
                            key: const ValueKey('register'),
                            emailCtrl: _emailCtrl,
                            passwordCtrl: _passwordCtrl,
                            firstNameCtrl: _firstNameCtrl,
                            lastNameCtrl: _lastNameCtrl,
                            confirmCtrl: _confirmCtrl,
                            obscurePassword: _obscurePassword,
                            obscureConfirm: _obscureConfirm,
                            birthDate: _birthDate,
                            onToggleObscure: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            onToggleConfirm: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                            onBirthDateChanged: (date) =>
                                setState(() => _birthDate = date),
                            onSubmit: _register,
                            isLoading: _isLoading,
                          ),
                  ),

                  // ── Message d'état ──
                  AnimatedSwitcher(
                    duration: _LC.anim,
                    child: _message.isEmpty
                        ? const SizedBox.shrink()
                        : _StatusMessage(
                            key: ValueKey(_message),
                            message: _message,
                            isError: _isError,
                          ),
                  ),

                  const SizedBox(height: 28),
                  _Divider(),
                  const SizedBox(height: 24),

                  // ── Boutons sociaux ──
                  _SocialButton(
                    label: 'Continuer avec Google',
                    icon: _GoogleIcon(),
                    onTap: () => _socialLogin('Google'),
                  ),
                  const SizedBox(height: 12),
                  _SocialButton(
                    label: 'Continuer avec Apple',
                    icon: const Icon(Icons.apple, size: 20),
                    onTap: () => _socialLogin('Apple'),
                  ),

                  const SizedBox(height: 36),

                  if (widget.showSkipButton) _SkipButton(onTap: _skipLogin),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FOND DÉCORATIF
// ─────────────────────────────────────────────
class _BackgroundDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -80, right: -60,
              child: _BlurCircle(
                  size: 260,
                  color: FigmaContract.primary.withOpacity(0.12)),
            ),
            Positioned(
              bottom: -100, left: -80,
              child: _BlurCircle(
                  size: 320,
                  color: FigmaContract.primary.withOpacity(0.06)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ─────────────────────────────────────────────
//  LOGO
// ─────────────────────────────────────────────
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ← Remplace par ton vrai logo : Image.asset('assets/logo.png')
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: FigmaContract.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 20),
        Text(
          'Bienvenue !',
          style: FigmaContract.h1()
              .copyWith(color: Theme.of(context).colorScheme.onSurface, fontSize: 30),
        ),
        const SizedBox(height: 6),
        Text(
          'Connecte-toi pour continuer',
          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary, fontSize: 15),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  TAB BAR
// ─────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(_LC.radius),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: FigmaContract.primary,
          borderRadius: BorderRadius.circular(_LC.radius - 4),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        tabs: const [Tab(text: 'Connexion'), Tab(text: 'Inscription')],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FORMULAIRE CONNEXION
// ─────────────────────────────────────────────
class _LoginForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final bool isLoading;

  const _LoginForm({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AppTextField(
          controller: emailCtrl,
          label: 'Email',
          hint: 'toi@exemple.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: passwordCtrl,
          label: 'Mot de passe',
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscure: obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
              size: 20,
            ),
            onPressed: onToggleObscure,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {}, // TODO: mot de passe oublié
            child: Text(
              'Mot de passe oublié ?',
              style: TextStyle(
                color: FigmaContract.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _PrimaryButton(label: 'Se connecter', onTap: onSubmit, isLoading: isLoading),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  FORMULAIRE INSCRIPTION
// ─────────────────────────────────────────────
class _RegisterForm extends StatelessWidget {
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController confirmCtrl;
  final bool obscurePassword;
  final bool obscureConfirm;
  final DateTime? birthDate;
  final VoidCallback onToggleObscure;
  final VoidCallback onToggleConfirm;
  final ValueChanged<DateTime> onBirthDateChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const _RegisterForm({
    super.key,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.confirmCtrl,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.birthDate,
    required this.onToggleObscure,
    required this.onToggleConfirm,
    required this.onBirthDateChanged,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _AppTextField(
                controller: firstNameCtrl,
                label: 'Prénom',
                icon: Icons.person_outline_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AppTextField(
                controller: lastNameCtrl,
                label: 'Nom',
                icon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: emailCtrl,
          label: 'Email',
          hint: 'toi@exemple.com',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: passwordCtrl,
          label: 'Mot de passe',
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscure: obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
              size: 20,
            ),
            onPressed: onToggleObscure,
          ),
        ),
        const SizedBox(height: 14),
        _AppTextField(
          controller: confirmCtrl,
          label: 'Confirmer le mot de passe',
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscure: obscureConfirm,
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
              size: 20,
            ),
            onPressed: onToggleConfirm,
          ),
        ),
        const SizedBox(height: 14),
        _BirthDatePicker(value: birthDate, onChanged: onBirthDateChanged),
        const SizedBox(height: 24),
        _PrimaryButton(label: 'Créer mon compte', onTap: onSubmit, isLoading: isLoading),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  SÉLECTEUR DATE DE NAISSANCE
// ─────────────────────────────────────────────
class _BirthDatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const _BirthDatePicker({required this.value, required this.onChanged});

  void _open(BuildContext context) {
    final now = DateTime.now();
    int selDay   = value?.day   ?? 1;
    int selMonth = value?.month ?? 1;
    int selYear  = value?.year  ?? (now.year - 18);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: FigmaContract.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text('Date de naissance',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: _PickerDropdown<int>(
                      label: 'Jour',
                      value: selDay,
                      items: List.generate(31, (i) => i + 1),
                      display: (d) => d.toString().padLeft(2, '0'),
                      onChanged: (v) => setModal(() => selDay = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: _PickerDropdown<int>(
                      label: 'Mois',
                      value: selMonth,
                      items: List.generate(12, (i) => i + 1),
                      display: (m) => _LC.months[m - 1],
                      onChanged: (v) => setModal(() => selMonth = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: _PickerDropdown<int>(
                      label: 'Année',
                      value: selYear,
                      items: List.generate(100, (i) => now.year - 5 - i),
                      display: (y) => y.toString(),
                      onChanged: (v) => setModal(() => selYear = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FigmaContract.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    final maxDay =
                        DateUtils.getDaysInMonth(selYear, selMonth);
                    onChanged(DateTime(
                        selYear, selMonth, selDay.clamp(1, maxDay)));
                    Navigator.pop(ctx);
                  },
                  child: const Text('Confirmer',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = value == null
        ? 'Date de naissance'
        : '${value!.day.toString().padLeft(2, '0')} '
          '${_LC.months[value!.month - 1]} '
          '${value!.year}';

    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(_LC.radius),
          border: Border.all(color: FigmaContract.border.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined,
                color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: value == null
                      ? Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DROPDOWN RÉUTILISABLE
// ─────────────────────────────────────────────
class _PickerDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) display;
  final ValueChanged<T> onChanged;

  const _PickerDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: FigmaContract.border.withOpacity(0.4)),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            dropdownColor: Theme.of(context).scaffoldBackgroundColor,
            style:
                TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(display(item)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CHAMP DE TEXTE RÉUTILISABLE
// ─────────────────────────────────────────────
class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _AppTextField({
    required this.controller,
    required this.label,
    this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle:
            TextStyle(color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary.withOpacity(0.5)),
        labelStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon:
            Icon(icon, color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_LC.radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_LC.radius),
          borderSide: BorderSide(
              color: FigmaContract.border.withOpacity(0.4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_LC.radius),
          borderSide:
              BorderSide(color: FigmaContract.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOUTON PRINCIPAL
// ─────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: FigmaContract.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              FigmaContract.primary.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_LC.radius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DIVISEUR "ou"
// ─────────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
              color: FigmaContract.border.withOpacity(0.4), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('ou',
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary, fontSize: 13)),
        ),
        Expanded(
          child: Divider(
              color: FigmaContract.border.withOpacity(0.4), thickness: 1),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BOUTON SOCIAL
// ─────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: icon,
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          textStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          side: BorderSide(
              color: FigmaContract.border.withOpacity(0.5), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_LC.radius),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ICÔNE GOOGLE
// ─────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final cx = r, cy = r;

    void arc(Color c, double start, double sweep) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 3),
        start, sweep, false,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.38,
      );
    }

    arc(const Color(0xFF4285F4), -0.22, 1.6);
    arc(const Color(0xFF34A853),  1.38, 1.6);
    arc(const Color(0xFFFBBC05),  2.98, 0.8);
    arc(const Color(0xFFEA4335),  3.78, 0.8);

    canvas.drawLine(
      Offset(cx, cy), Offset(cx + r * 0.82, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = r * 0.36
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
//  MESSAGE D'ÉTAT
// ─────────────────────────────────────────────
class _StatusMessage extends StatelessWidget {
  final String message;
  final bool isError;

  const _StatusMessage({
    super.key,
    required this.message,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isError ? const Color(0xFFEF4444) : const Color(0xFF22C55E);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(_LC.radius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: color, size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOUTON SKIP (dev uniquement)
// ─────────────────────────────────────────────
class _SkipButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SkipButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.code_rounded,
            size: 14,
            color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary.withOpacity(0.5)),
        label: Text(
          'Passer (mode dev)',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
    );
  }
}