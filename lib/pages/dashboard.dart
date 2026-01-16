import 'package:flutter/material.dart';
import 'package:zitoun/pages/chatbot/chatbot.dart';
import 'package:zitoun/pages/history/history.dart';
import 'package:zitoun/theme/app_theme.dart';
import 'package:zitoun/pages/home/home.dart';
import 'package:zitoun/pages/facture/facture.dart';
import 'package:zitoun/pages/stock/stock.dart';
import 'package:zitoun/pages/client/client_page.dart';
import 'package:zitoun/pages/settings/settings.dart';
import 'package:zitoun/pages/map/map.dart'; 

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key,required this.pageIndex});
  final int pageIndex;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late int selectedIndex;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex;   // ✔ load initial page
  }

  final List<Widget> _pages = const [
    //Center(child: Text('Accueil', style: TextStyle(fontSize: 17))),
    Home(),
    StockPage(),
    HistoryPage(),
    Invoice(),
    ClientsPage(),
    MoroccoMapPage(),
    SettingsPage(),
    Center(child: Text('A propos', style: TextStyle(fontSize: 17))),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
  body: Stack(
    children: [
      // 1. Wrap Row in Positioned.fill to fix bottom overflow (964px error)
      Positioned.fill(
        child: Row(
          children: [
            // Sidebar Navigation
            MouseRegion(
              onEnter: (_) => setState(() => isExpanded = true),
              onExit: (_) => setState(() => isExpanded = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isExpanded ? 220 : 70,
                // 2. Add clipBehavior to cleanly cut off content during animation
                clipBehavior: Clip.hardEdge, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: theme.colorScheme.surface,
                  border: Border(
                    right: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                // 3. Wrap Column in ScrollView (Horizontal, Locked) + SizedBox
                // This forces the inner content to always be 220px wide, 
                // preventing the "squishing" glitch during animation.
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(), // Prevents user scrolling
                  child: SizedBox(
                    width: 220, // Force content to be max width
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Top logo
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              AppTheme.img,
                              width: 35,
                              height: 35,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
        
                        // Navigation buttons
                        _navItem(
                          index: 0,
                          icon: Icons.dashboard,
                          label: 'Dashboard',
                        ),
                        const SizedBox(height: 8),
                        _navItem(
                          index: 1,
                          icon: Icons.warehouse,
                          label: 'Stock',
                        ),
                        const SizedBox(height: 8),
                        _navItem(
                          index: 2,
                          icon: Icons.history,
                          label: 'Historique',
                        ),
                        _navItem(
                          index: 3,
                          icon: Icons.receipt_long,
                          label: 'Facture',
                        ),
                        const SizedBox(height: 8),
                        _navItem(
                          index: 4,
                          icon: Icons.account_box,
                          label: 'Clients',
                        ),
                         _navItem(
                          index: 5,
                          icon: Icons.gps_fixed,
                          label: 'Map',
                        ),
                        const SizedBox(height: 8),
                        _navItem(
                          index: 6,
                          icon: Icons.settings,
                          label: 'Parametres',
                        ),
                        const SizedBox(height: 8),
                        _navItem(
                          index: 7,
                          icon: Icons.info,
                          label: 'A propos',
                        ),
                        
                        // Spacer now works because of Positioned.fill
                        const Spacer(), 
        
                        // Bottom section
                        // Note: Removed the "if (isExpanded)" check here so the 
                        // layout doesn't jump, opacity will handle visibility implicitly
                        // or you can keep it, but the width fix above makes it safe.
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'v1.0.0',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            // Main content area
            Expanded(
              child: Container(
                color: theme.colorScheme.background,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Container(
                    key: ValueKey(selectedIndex),
                    child: _pages[selectedIndex],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Theme toggle button
      Positioned(
        top: 20,
        right: 20,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
      ),
      ChatBot(),
    ],
  ),
);
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final bool active = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => setState(() => selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: active
                ? theme.colorScheme.primary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: active
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                      color: active
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
  
}

