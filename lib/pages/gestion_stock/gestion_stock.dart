import 'package:flutter/material.dart';
import 'package:zitoun/pages/gestion_stock/ressource.dart';
import 'olives.dart';

class GestionDeStock extends StatefulWidget {
  GestionDeStock({Key? key,required this.context}) : super(key: key);
  final BuildContext context;

  @override
  State<GestionDeStock> createState() => _GestionDeStockState();
}

class _GestionDeStockState extends State<GestionDeStock> {
  String? selectedResource;

  final List<Map<String, String>> olives = [
    {'id': 'olive1', 'name': 'Olive Noire', 'image': 'images/noir.png'},
    {'id': 'olive2', 'name': 'Olive Hare', 'image': 'images/har.png'},
    {'id': 'olive3', 'name': 'Olive Mcharmal', 'image': 'images/mcharmal.png'},
    {'id': 'olive4', 'name': 'Olive sans Os', 'image': 'images/sansos.png'},
  ];

  final List<Map<String, String>> autresRessources = [
    {'id': 'boite', 'name': 'Boites', 'image': 'images/boite.png'},
    {'id': 'carton', 'name': 'Carton', 'image': 'images/carton.png'},
    {'id': 'lessieur', 'name': 'Lessieur', 'image': 'images/lessieur.png'},
    {'id': 'z3tar', 'name': 'Za3tar', 'image': 'images/z3tar.png'},
    {'id': 'hrissa', 'name': 'Hrissa', 'image': 'images/hrissa.png'},
    {'id': 'citron', 'name': 'Citron', 'image': 'images/citron.png'},
  ];

  Widget _buildResourceBox(Map<String, String> resource) {
    final isSelected = selectedResource == resource['id'];
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedResource = resource['id'];
        });
      },
      child: Container(
        width: 140,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.redAccent : theme.colorScheme.primary,
            width: isSelected ? 3 : 1,
          ),
          image: DecorationImage(
            image: AssetImage(resource['image']!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: isSelected
              ? Text(
                  resource['name']!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.transparent,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildDynamicContent() {
    final theme = Theme.of(context);
    
    if (selectedResource == null) {
      return Center(
        child: Text(
          'Please select a resource',
          style: TextStyle(fontSize: 16, color: theme.colorScheme.primary),
        ),
      );
    } else if (selectedResource == 'olive1') {
      return OliveStock(selectedResource: 'Olive Noire',context:widget.context );
    }
    else if (selectedResource == 'olive2') {
      return OliveStock(selectedResource: 'Olive Hare',context:widget.context );
    }
        else if (selectedResource == 'olive3') {
      return OliveStock(selectedResource: 'Olive Mcharmal',context:widget.context);
    }
        else if (selectedResource == 'olive4') {
      return OliveStock(selectedResource: 'Olive sans Os',context:widget.context );
    }
     
     else {
      return Ressource(selectedResource: selectedResource!, );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 750,
        height: 700,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Make the top sections scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Olives Section
                    const Text(
                      'Olives',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: olives.map((olive) => _buildResourceBox(olive)).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Autres Ressources Section
                    const Text(
                      'Autre Ressources',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: autresRessources
                          .map((resource) => _buildResourceBox(resource))
                          .toList(),
                    ),
                    const SizedBox(height: 32),

                    // Dynamic Content Section
                    Container(
                      constraints: const BoxConstraints(minHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        //borderRadius: BorderRadius.circular(12),
                        //border: Border.all(color: Colors.grey[300]!),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: _buildDynamicContent(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for OliveStock widget


// Example usage - Button to show the dialog
class ShowDialogButton extends StatelessWidget {
  const ShowDialogButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => GestionDeStock(context:context,),
        );
      },
      child: const Text('Open Resource Selector'),
    );
  }
}