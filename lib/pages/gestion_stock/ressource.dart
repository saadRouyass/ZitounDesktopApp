import 'package:flutter/material.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:zitoun/services/db.dart';

class Ressource extends StatefulWidget {
  final String selectedResource;

  const Ressource({
    super.key,
    required this.selectedResource,
  });

  @override
  State<Ressource> createState() => _RessourceState();
}

class _RessourceState extends State<Ressource> {
  final TextEditingController quantityController = TextEditingController();

  double quantity = 0;

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  Future<void> addStock(BuildContext context) async {
    try {
      await insertRessource(
        date: DateTime.now(),
        ressourceType: widget.selectedResource,
        quantity: quantity,
        price: 0,
      );

      SysNotif.showWidget(
        context,
        'Ajout du stock effectué avec succès',
        Colors.greenAccent,
        Icons.check,
      );
    } catch (e) {
      SysNotif.showWidget(
        context,
        "Erreur lors de l’insertion",
        Colors.redAccent,
        Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.selectedResource,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Quantity",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              setState(() {
                quantity = double.tryParse(val) ?? 0;
              });
            },
          ),

          const SizedBox(height: 20),

          Center(
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.redAccent),
              ),
              onPressed: quantity > 0
                  ? () => addStock(context)
                  : null,
              child: Text(
                "Ajouter Stock",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
