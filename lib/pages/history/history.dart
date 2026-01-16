import 'package:flutter/material.dart';
import 'package:zitoun/db/products.dart';

Map<String, String> createUnitsMap() {
  final Map<String, String> units = {};

  for (int i = 0; i < productNames.length; i++) {
    units[productNames[i]] = productUnits[i];
  }
  print(units);
  return units;
}

final Map<String, String> units = createUnitsMap();

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // ================= FILTER STATE =================
  String _selectedCategory = 'All'; 
  String _selectedProductType = 'All';
  DateTime? _selectedDate;

  // ================= FILTERED DATA =================
  List get filteredHistory {
    return productsHistory.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          (_selectedCategory == 'Stock' && item.price >= 0) ||
          (_selectedCategory == 'Facture' && item.price < 0);

      final matchesProduct =
          _selectedProductType == 'All' ||
          item.productType == _selectedProductType;

      final matchesDate =
          _selectedDate == null ||
          item.date.toString().split(' ')[0] ==
              _selectedDate.toString().split(' ')[0];

      return matchesCategory && matchesProduct && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),

            // ================= TITLE =================
            Text(
              "Historique",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // ================= FILTER BAR =================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  // TYPE FILTER
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: ['All', 'Stock', 'Facture']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategory = val!),
                  ),

                  const SizedBox(height: 10),

                  // PRODUCT FILTER
                  DropdownButtonFormField<String>(
                    value: _selectedProductType,
                    decoration:
                        const InputDecoration(labelText: 'Produit'),
                    items: ['All', ...productNames]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedProductType = val!),
                  ),

                  const SizedBox(height: 10),

                  // DATE FILTER
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Aucune date sélectionnée'
                              : _selectedDate!
                                  .toString()
                                  .split(' ')[0],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: const Text('Choisir'),
                      ),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () =>
                              setState(() => _selectedDate = null),
                        )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= HISTORY LIST =================
            Column(
              children: List.generate(
                filteredHistory.length,
                (i) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.cardColor,
                    border: Border.all(color: Colors.black12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: filteredHistory[i].price >= 0
                              ? Colors.greenAccent.withOpacity(0.1)
                              : Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          filteredHistory[i].price >= 0
                              ? Icons.inventory_2
                              : Icons.local_shipping,
                          color: filteredHistory[i].price >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Date
                      Expanded(
                        flex: 2,
                        child: Text(
                          filteredHistory[i]
                              .date
                              .toString()
                              .split(' ')[0],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Type
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Stock ${filteredHistory[i].productType}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),

                      // Quantity
                      Expanded(
                        flex: 1,
                        child: Text(
                          filteredHistory[i].quantity.toString(),
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Price
                      Text(
                        '${filteredHistory[i].price.toStringAsFixed(2)} DH',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: filteredHistory[i].price >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
