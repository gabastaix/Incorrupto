import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final ValueChanged<String> onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  String _message = '';
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    try {
      final response = await _authService.login(_email, _password);
      final token = response['access_token'] as String;
      final profile = await _authService.getMe(token);
      final firstName = profile['first_name'] as String? ?? '';
      final displayName = firstName.isNotEmpty ? firstName : _deriveUserName(_email);
      widget.onLogin(displayName);
    } catch (e) {
      setState(() {
        _message = 'Échec : Email ou mot de passe incorrect.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _deriveUserName(String email) {
    final localPart = email.split('@').first;
    final cleaned = localPart.replaceAll(RegExp(r'[._\-]+'), ' ').trim();
    if (cleaned.isEmpty) return '';
    final firstWord = cleaned.split(' ').first;
    return firstWord[0].toUpperCase() + firstWord.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaContract.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Connexion',
                  style: FigmaContract.h1()
                      .copyWith(color: FigmaContract.textPrimary)),
              const SizedBox(height: 40),
              TextField(
                onChanged: (value) => _email = value,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => _password = value,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Se connecter'),
                    ),
              const SizedBox(height: 20),
              Text(_message,
                  style: TextStyle(
                      color: _message.contains('Échec') ? Colors.red : Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}