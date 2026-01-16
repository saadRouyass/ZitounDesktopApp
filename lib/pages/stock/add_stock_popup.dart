import 'package:flutter/material.dart';
import 'package:zitoun/db/products.dart';
import 'package:zitoun/services/db.dart';

class AddStockPopup extends StatelessWidget {
  AddStockPopup({super.key});
  final List<DropdownMenuItem<String>> productTypes = [];
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
 
  String selectedProductType='';

  @override
  Widget build(BuildContext context) {
    
    for (var name in productNames) {
    productTypes.add(DropdownMenuItem(value: name, child: Text(name)));
    }
    
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
                  child: Text('Ajouter Stock',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: theme.colorScheme.primary),),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    
                    labelText: 'Type de Produit',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                  items: productTypes,
                  onChanged: (value) {
                                      selectedProductType=value as String;
                                      },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    
                    labelText: 'Quantité Totale',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
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
                
                const SizedBox(height: 24),

                SizedBox(
                  
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary)),
                    onPressed: () async{
                      await insertProductHistory(
                        date: DateTime.now(),
                        productType: selectedProductType,
                        quantity: (int.parse(quantityController.text)  as num).toDouble() ,
                        price: (int.parse(unitPriceController.text)  as num).toDouble() * (int.parse(quantityController.text)  as num).toDouble(),);

                    },
                    child:  Text('Ajouter Stock',style: TextStyle(color: theme.colorScheme.background),),
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