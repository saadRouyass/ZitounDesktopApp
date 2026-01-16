import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'auth/auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zitoun/pages/firstpage.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zitoun/db/products.dart';
import 'package:zitoun/db/clients.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Initializing SUPABASE 
  await windowManager.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  WindowOptions windowOptions = const WindowOptions(

    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal
     
  );

  await Supabase.initialize(
    url: 'https://tjzbwlvluibljghlzcrg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqemJ3bHZsdWlibGpnaGx6Y3JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwMjUwODYsImV4cCI6MjA4MDYwMTA4Nn0.PN-el1dVb3vCuKfLp6xqsZVrL07GYP65yR3j27wtIrg',
  );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.maximize();
    await windowManager.show();
    await windowManager.focus();
    
  });

  try {
    await loadAllProductsData();
    await loadClients();
  } catch (e) {
    print("Error loading products data: $e");
  }

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Desktop Auth App',
          theme: theme,
          home: FirstPage(nextScreen: AuthPage()), // Changed this line
        );
      },
    );
  }
}