import 'package:flutter/material.dart';
import 'package:zitoun/pages/gestion_stock/olive_functions.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:zitoun/services/db.dart';

class OliveStock extends StatefulWidget {
  final String selectedResource;
  final BuildContext context;
  const OliveStock({super.key, required this.selectedResource ,required this.context});

  @override
  State<OliveStock> createState() => _OliveStockState();
}

class _OliveStockState extends State<OliveStock> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController boites = TextEditingController();
  final TextEditingController carton = TextEditingController();
  final TextEditingController lessieur= TextEditingController();
  final TextEditingController za3tar = TextEditingController();
  final TextEditingController hrissa = TextEditingController();
  final TextEditingController citron = TextEditingController();

  // Example calculated fields
  double field2 = 0;
  double field3 = 0;
  double field4 = 0;
  double field5 = 0;
  double field6 = 0;
  double field7 = 0;

  void _calculate(String oliveType) {
    List <String> outputs = calculateOliveStock(oliveType,inputController.text);

    setState(() {
      field2 = double.parse(outputs[0]);  
      field3 = double.parse(outputs[1]);
      field4 = double.parse(outputs[2]); 
      field5 = double.parse(outputs[3]); 
      field6 = double.parse(outputs[4]); 
      field7 = double.parse(outputs[5]); 
    });
  }

Future<void> addStock(BuildContext context,BuildContext rootContext) async {
  // Close the dialog first
  

  // Show the "pending" notification safely
  if (widget.selectedResource == 'Olive Noire') {
    try {
    await insertOliveN(date: DateTime.now(), boites: field2, price: 0, cartonQuantity: field3, cartonPrice: 0, lessieurQuantity: field4, lessieurPrice: 0);
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
  else if(widget.selectedResource == 'Olive Hare') {
    try {
    await insertOliveH(date: DateTime.now(), boites: field2, price: 0, cartonQuantity: field3, cartonPrice: 0, lessieurQuantity: field4, lessieurPrice: 0, za3tarQuantity: field5, za3tarPrice: 0, hrissaQuantity: field6, hrissaPrice: 0);
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
  else if(widget.selectedResource == 'Olive Mcharmal') {
    try {
    await insertOliveM(date: DateTime.now(), boites: field2, price: 0, cartonQuantity: field3, cartonPrice: 0, lessieurQuantity: field4, lessieurPrice: 0, za3tarQuantity: field5, za3tarPrice: 0, citronQuantity: field7, citronPrice: 0);
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
    else if(widget.selectedResource == 'Olive sans Os') {
    try {
    await insertOliveS(date: DateTime.now(), boites: field2, price: 0, cartonQuantity: field3, cartonPrice: 0);
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
  
    

  


  // Wait 6 seconds
  //await Future.delayed(Duration.zero);

  // Show the "success" notification
  /*
  SysNotif.showWidget(
    rootContext,
    'Stock ajouté avec succès',
    presets["success"]!,
    Icons.check,
  );*/
}



  @override
  Widget build(BuildContext context) {

    //_calculate(widget.selectedResource);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(widget.selectedResource,style: TextStyle(color:theme.colorScheme.primary,fontWeight: FontWeight.w300,fontSize: 20),),),
          const SizedBox(height: 20),
          // FIRST INPUT (user writes here)
          TextField(
            controller: inputController,
            decoration: const InputDecoration(
              labelText: "Barmil nombre",
              labelStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _calculate(widget.selectedResource),
          ),

          const SizedBox(height: 20),
          // CALCULATED FIELD (modifiable)
          TextField(
            
            decoration: const InputDecoration(
              
              labelText: "boites",
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: field2.toString() + ' unites'),
            onChanged: (val) {
              field2 = double.tryParse(val) ?? field2;
            },
          ),

          const SizedBox(height: 20),

          // CALCULATED FIELD (modifiable)
          TextField(
            decoration: const InputDecoration(
              labelText: "carton",
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: field3.toString() + ' unites'),
            onChanged: (val) {
              field3 = double.tryParse(val) ?? field3;
            },
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: const InputDecoration(
              labelText: "lessieur",
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: field4.toString()+ ' litre'),
            onChanged: (val) {
              field4 = double.tryParse(val) ?? field4;
            },
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: const InputDecoration(
              labelText: "za3tar",
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: field5.toString()+ ' kg'),
            onChanged: (val) {
              field5 = double.tryParse(val) ?? field5;
            },
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: const InputDecoration(
              labelText: "hrissa",
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: field6.toString() + ' kg'),
            onChanged: (val) {
              field6 = double.tryParse(val) ?? field6;
            },
          ),

          const SizedBox(height: 20),

          TextField(
            decoration: const InputDecoration(
              labelText: "citron",
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: field7.toString()+ ' kg'),
            onChanged: (val) {
              field7 = double.tryParse(val) ?? field7;
            },
          ),

          const SizedBox(height: 20),

          Center(child: TextButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent),),
                                  onPressed: (){addStock(context,widget.context);}, 
                                  child: Text("Ajouter Stock",style: TextStyle(color: theme.colorScheme.primary,fontWeight:FontWeight.w600),))),
        ],
      ),
    );
  }
}
