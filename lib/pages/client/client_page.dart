import 'package:flutter/material.dart';
import 'package:zitoun/db/clients.dart';
import 'package:zitoun/pages/client/add_client.dart';
import 'package:zitoun/pages/client/client_card.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      
      body: ListView(
    padding: const EdgeInsets.all(24.0),
    children: [
      Row(
          children: [
            Text("Liste des Clients", style: TextStyle(fontWeight: FontWeight.w300,fontSize: 24)),
            const SizedBox(width: 26),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary,
                
              ),
              width: 40,
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.add, color: theme.colorScheme.surface),
                alignment: Alignment.center,
                onPressed: () {
                      showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => AddClient(),
                    );
                },
              ),
            ),
            
          ],
        ),

      const SizedBox(height: 16),

      ListView.builder(
        itemCount: clients.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ClientCard(
            client: clients[index],
          );
        },
      ),
    ],
  ),
    );
  }
}
