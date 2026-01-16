import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zitoun/db/clients.dart';
import 'package:zitoun/services/db.dart';
import 'package:zitoun/services/get_facture.dart';
import 'package:zitoun/db/products.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  // ------------------ DATE ------------------
  DateTime selectedDate = DateTime.now();

  // ------------------ ADDRESS ------------------
  final List<String> addressHistory = clientsNames;
  String? selectedAddress;

  // ------------------ ITEMS ------------------
  final List<String> itemHistory = productNames;


  List<List<dynamic>> articles = [

  ];

  //items to pass to the api 
  List<Map<String, dynamic>> formatArticles() {
  return articles.map((article) {
    return {
      "description": article[0].toString(),
      "quantity": int.tryParse(article[1].toString()) ?? 0,
      "unitPrice": article[2] ?? 0,
      "tax": article[3] ?? 0,
      "total": article[4].toString().replaceAll(' DH', '').trim() != ''
          ? double.tryParse(article[4].toString().replaceAll(' DH', '').trim()) ?? 0
          : 0,
    };
  }).toList();
}
  //calculate subTotal and totalTTC
  List<double> calculateTotals() {
    double subtotal = 0.0;
    double taxTotal = 0.0;

    for (var article in articles) {
      final quantity = double.tryParse(article[1].toString()) ?? 0;
      final unitPrice = double.tryParse(article[2].toString()) ?? 0;
      final taxPercent = double.tryParse(article[3].toString()) ?? 0;

      final itemSubtotal = quantity * unitPrice;
      final itemTax = itemSubtotal * (taxPercent / 100);

      subtotal += itemSubtotal;
      taxTotal += itemTax;
    }
    return [subtotal, taxTotal];

  }

  List<Widget> buildArticleColumns() {
  final theme = Theme.of(context);
  return List.generate(articles.length, (index) {
    final article = articles[index];

    return Column(
  children: [
    Row(
      mainAxisSize: MainAxisSize.min, // optional
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(article[0].toString()),
        ),
        SizedBox(
          width: 50,
          child: Text(article[1].toString()),
        ),
        SizedBox(
          width: 80,
          child: Text(article[4].toString()),
        ),
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.redAccent,
          ),
          onPressed: () {
            setState(() {
              articles.removeAt(index);
            });
          },
        ),
      ],
    ),

    // <-- This adds a horizontal line after each row
    SizedBox(
    width: 290, // desired width
    child: Divider(
      color: theme.colorScheme.primary,
      thickness: 1,
      height: 16,
    ),
  ),
  ],
);
    
  });
}

void updateArticles() {
  final qty = double.tryParse(quantityCtrl.text) ?? 0;
  final unitPrice = double.tryParse(unitPriceCtrl.text) ?? 0;
  final tax = double.tryParse(taxCtrl.text) ?? 0;

  final subtotal = qty * unitPrice;
  final taxValue = subtotal * (tax / 100);
  final articleTotal = subtotal + taxValue;

  setState(() {
    articles.add([
      selectedItem,
      qty.toInt(),
      unitPrice,
      tax,
      '${articleTotal.toStringAsFixed(2)} DH',
    ]);

    // reset for next item
    totalPrice = 0;
    quantityCtrl.text = '1';
    unitPriceCtrl.clear();
    taxCtrl.text = '0';
  });
}

  final TextEditingController quantityCtrl = TextEditingController(text: '1');
  final TextEditingController unitPriceCtrl = TextEditingController();
  final TextEditingController taxCtrl = TextEditingController(text: '0');

  String? selectedItem;
  double totalPrice = 0.0;

  // ------------------ PRICE CALCULATION ------------------
  void calculateTotal() {
  final qty = double.tryParse(quantityCtrl.text) ?? 0;
  final unitPrice = double.tryParse(unitPriceCtrl.text) ?? 0;
  final tax = double.tryParse(taxCtrl.text) ?? 0;

  final subtotal = qty * unitPrice;
  final taxValue = subtotal * (tax / 100);

  setState(() {
    totalPrice = subtotal + taxValue;
  });
}

  // ------------------ DATE PICKER ------------------
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView( 
    child : ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: MediaQuery.of(context).size.height,
    ),
    child:Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Creer une facture', style: TextStyle(fontSize: 26,color: theme.colorScheme.primary, fontWeight: FontWeight.w300),),
          const SizedBox(height: 20),
          // ------------------ DATE ROW ------------------
          Text('Date', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          InkWell(
          onTap: pickDate,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.blue.withOpacity(0.2),
          child: Material(
            color: theme.colorScheme.surface, // background color
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              child: Text(
                DateFormat('dd/MM/yyyy').format(selectedDate),
              ),
            ),
          ),
        ),


          const SizedBox(height: 20),

          // ------------------ ADDRESS ------------------                                                                                    
          Text('Adresse de livraison', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Choisir ou saisir une adresse',
            filled: true,
            fillColor: theme.colorScheme.surface, // background color
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.onBackground, width: 1),
            ),
          ),
          items: addressHistory
              .map(
                (addr) => DropdownMenuItem<String>(
                  value: addr,
                  child: Text(addr, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() => selectedAddress = value);
          },
          onSaved: (value) => selectedAddress = value,
          isExpanded: true,
        ),

          const SizedBox(height: 20),

          // ------------------ ITEM ROW ------------------
          Text('Article', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              // ITEM
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Article',
                  ),
                  items: itemHistory
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedItem = value);
                  },
                ),
              ),
              const SizedBox(width: 8),

              // QUANTITY
              Expanded(
                child: TextFormField(
                  controller: quantityCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    labelText: 'Quantité',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  onChanged: (_) => calculateTotal(),
                ),
              ),
              const SizedBox(width: 8),

              // UNIT PRICE
              Expanded(
                child: TextFormField(
                  controller: unitPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    labelText: 'Prix Unitaire',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  onChanged: (_) => calculateTotal(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: taxCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    labelText: 'Tax %',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  onChanged: (_) => calculateTotal(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    labelText: 'Prix Total',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  child: Text(
                    '${totalPrice.toStringAsFixed(2)} DH',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(onPressed: updateArticles, child: Text('Ajouter', style: TextStyle(color: theme.colorScheme.primary),)),
            ],
          ),
          Row(
            children: [
            Text('Telecharger la facture', style:TextStyle(color: theme.colorScheme.primary, fontSize:16)),
            const SizedBox(width: 10),
            IconButton(
            icon: Icon(Icons.download, color: Colors.greenAccent,),
            onPressed: () async{
              final totals = calculateTotals();

              await downloadPdf(
                context,
                selectedDate.toString(),
                selectedAddress!,
                'Rabat',
                formatArticles(),
                totals[0],           // subtotal
                totals[1].toString(),// tax total
                totals[0] + totals[1], // total TTC
              );

              await substractItems(formatArticles());

            },
          ),
            ]
          ),
         
          const SizedBox(height: 20),
          Column(
            children: buildArticleColumns(),
          ),

        ],
      ),
    )
    ),
    );
  }
}
