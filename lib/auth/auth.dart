import 'package:flutter/material.dart';
import 'package:zitoun/auth/signup.dart';
import '../theme/app_theme.dart';
import 'package:zitoun/pages/dashboard.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:zitoun/pages/notifs/presets.dart';
import 'package:zitoun/services/db.dart';

class AuthPage extends StatelessWidget {
   AuthPage({super.key});

  //Text Controller
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  //dispose to prevent Memory leaks
  

  void checkCredentials(BuildContext context,String email,String password) async{
    //Inputs handler Logic

    if (email!='' && password!='') {
      bool ok = await  signIn(email, password);
      if (ok) {
        Navigator.push(context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(pageIndex: 0),
        ),
      );
      await Future.delayed(Duration(seconds: 1));
      SysNotif.showWidget(context, 'Bonjour User',presets['success']!,Icons.check);       
      }
      else{
        SysNotif.showWidget(context,'Mot de pass ou email incorrect',presets['failed']!,Icons.no_accounts);
      }
      
    }
    else if(email=='' || password==''){
      SysNotif.showWidget(context, 'Entrer vos informations',presets['in_review']!,Icons.error);
    }


  }

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
                  'Bonjour',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                  
                  
                ),
                const SizedBox(height: 40),
                _buildInput(theme, hint: 'Username',c:_userController),
                const SizedBox(height: 20),
                _buildInput(theme, hint: 'Password', obscure: true,c:_passController),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    checkCredentials(context,_userController.text,_passController.text);
                    
                    },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text('Enter'),
                ),
                const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(
                          builder: (_) => SignupPage()
                        ),);
                          
                          },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: theme.colorScheme.onSurface
                        ),
                        child: Text('Creer un compte',style: TextStyle(color:theme.colorScheme.background),),
                      ),                
                const SizedBox(height: 40),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mot de passe oublié ? ',),
                    GestureDetector(
                      onTap: () {
                        print('Forgot password clicked!');
                      },
                      child: Text(
                        'cliquer ici.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.blue,
                          
                        ),
                        selectionColor: Colors.redAccent,
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),

          Positioned(
            top: 20,
            right: 20,
            child: Row(
              children: [
                /*
                Text(
                  'THEME',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),*/
                const SizedBox(width: 10),
                
                SizedBox(
                width: 40,   // Control width
                height: 40,  // Control height
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: IconButton(
                onPressed: () {
                  AppTheme.toggleTheme();
                },
                icon: Icon(
                  AppTheme.theme_icon,
                  size: 24,
                ),
                color: theme.colorScheme.onSurface,
                tooltip: AppTheme.isDarkMode ? 'Light Mode' : 'Dark Mode',
              ),
                ),
              )
                
              ],
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
