import 'package:flutter/material.dart';
import 'package:zitoun/services/db.dart';


class AddProductPopup extends StatelessWidget {
  AddProductPopup({super.key});

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController minQuantityController = TextEditingController();
  String selectedUnit = 'kg';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // 👈 dialog width
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text('Ajouter un Type',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: theme.colorScheme.primary),),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: productNameController,
                  
                  decoration:  InputDecoration(
                    
                    fillColor: theme.colorScheme.onSurface,
                    labelText: 'Nom du produit',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),)
                    
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: unitPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Prix Unitaire',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: minQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min Quantité',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Unité',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'litre', child: Text('litre')),
                    DropdownMenuItem(value: 'piece', child: Text('piece')),
                  ],
                  onChanged: (value) {selectedUnit=value as String;},
                ),

                const SizedBox(height: 24),

                SizedBox(
                  
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary)),
                    onPressed: () async{
                      await insertProduct(productName: productNameController.text,
                       unitPrice: (int.parse(unitPriceController.text)  as num).toDouble() , 
                       unit: selectedUnit ,
                       minQuantity: (int.parse(minQuantityController.text)  as num).toDouble());
                       Navigator.pop(context);
                    },
                    child:  Text('Ajouter Produit',style: TextStyle(color: theme.colorScheme.background),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}