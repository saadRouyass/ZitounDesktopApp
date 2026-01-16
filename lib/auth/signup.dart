import 'package:flutter/material.dart';
import 'package:zitoun/auth/confirm.dart';
import 'package:zitoun/services/db.dart';
import 'package:zitoun/theme/app_theme.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:zitoun/pages/notifs/presets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();

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
                  'Créer un compte',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),

                const SizedBox(height: 40),

                _buildInput(theme, hint: 'Prénom', c: _firstName),
                const SizedBox(height: 15),

                _buildInput(theme, hint: 'Nom', c: _lastName),
                const SizedBox(height: 15),

                _buildInput(theme, hint: 'Email', c: _email),
                const SizedBox(height: 15),

                _buildInput(theme, hint: 'Numéro de téléphone', c: _phone),
                const SizedBox(height: 15),

                _buildInput(theme, hint: 'Mot de passe', obscure: true, c: _password),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () async{
                    if (_email.text=='' || _password.text=='' || _firstName.text=='' || _lastName.text=='' || _phone.text=='' ) {
                      SysNotif.showWidget(context, 'Remplissez tous les champs!',presets['in_review']!,Icons.error);
                    }
                    else{
                    bool ok = await signUp(_email.text, _password.text, _firstName.text,
                     _lastName.text, _phone.text);
                    if (ok) {
                      Navigator.push(context,MaterialPageRoute(
                      builder: (_) => CodeConfirmationPage(),
                    ),);
                    } else {
                      print('not ok');
                    }
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text('Créer mon compte'),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "Déjà un compte ? Se connecter",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // theme icon
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



  Widget _buildInput(ThemeData theme, {required String hint, bool obscure = false,
  required TextEditingController c}) {
    return SizedBox(
      width: 450,
      child: TextField(
        controller: c,
        style: TextStyle(fontWeight:FontWeight.w300),
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
