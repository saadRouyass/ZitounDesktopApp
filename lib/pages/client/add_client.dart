import 'package:flutter/material.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:zitoun/services/db.dart';


class AddClient extends StatelessWidget {
  AddClient({super.key});

  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800, // dialog width
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
                  child: Text('Ajouter un Client',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: theme.colorScheme.primary),),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  
                  decoration:  InputDecoration(
                    
                    fillColor: theme.colorScheme.onSurface,
                    labelText: 'Addresse',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),)
                    
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'numero de telephone',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                ),

                const SizedBox(height: 16),

                                TextFormField(
                  controller: cityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'city',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)),),
                  ),
                ),

                const SizedBox(height: 16),

              

                SizedBox(
                  
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary)),
                    onPressed: () async{
                      try {
                        await insertClient(address: addressController.text, email: emailController.text, phonenumber: phoneNumberController.text, city: cityController.text);
                        SysNotif.showWidget(context, 'Ajout du client effectué avec succès',Colors.greenAccent,Icons.check);
                      } catch (e) {
                        SysNotif.showWidget(context, "Erreur", Colors.redAccent, Icons.error);
                      }
                      
                    },
                    child:  Text('Ajouter Client',style: TextStyle(color: theme.colorScheme.background),),
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