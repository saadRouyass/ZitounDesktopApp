import 'package:flutter/material.dart';


class SysNotif {
  static OverlayEntry? _currentOverlay;

  static void showWidget(
    BuildContext context,
    String message,
    Color color,
    IconData icon, {
    double desktopWidth = 420,
  }) {
    // Remove previous notification if any
    _currentOverlay?.remove();

    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 600;
        final width = isDesktop ? desktopWidth : screenWidth - 32;

        return Positioned(
          top: 30,
          left: (screenWidth - width) / 2,
          width: width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: StatusPopup(
                icon: icon,
                text: message,
                color: color,
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
    _currentOverlay = overlayEntry;

    Future.delayed(const Duration(seconds: 4), () {
      overlayEntry.remove();
      if (_currentOverlay == overlayEntry) _currentOverlay = null;
    });
  }
}



class StatusPopup extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const StatusPopup({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.22),
            color.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}