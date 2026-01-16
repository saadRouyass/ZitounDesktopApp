import 'package:flutter/material.dart';
import 'package:zitoun/theme/app_theme.dart';

class CodeConfirmationPage extends StatefulWidget {
  const CodeConfirmationPage({super.key});

  @override
  State<CodeConfirmationPage> createState() => _CodeConfirmationPageState();
}

class _CodeConfirmationPageState extends State<CodeConfirmationPage> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmer le code',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),

                const SizedBox(height: 40),

                _buildInput(theme, hint: 'Entrez votre code', c: _codeController),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _confirmCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          ),

          // Theme toggle icon
          Positioned(
            top: 20,
            right: 20,
            child: SizedBox(
              width: 40,
              height: 40,
              child: FittedBox(
                fit: BoxFit.fill,
                child: IconButton(
                  onPressed: () {
                    AppTheme.toggleTheme();
                  },
                  icon: Icon(AppTheme.theme_icon),
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCode() {
    print("Code entered: ${_codeController.text}");
    // TODO: implement API verification or navigation
  }

  Widget _buildInput(ThemeData theme, {required String hint, bool obscure = false,
    required TextEditingController c}) {
    return SizedBox(
      width: 450,
      child: TextField(
        controller: c,
        style: const TextStyle(fontWeight: FontWeight.w300),
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        ),
      ),
    );
  }
}
