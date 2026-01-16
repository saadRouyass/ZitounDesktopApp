import 'package:flutter/material.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';
import 'package:zitoun/pages/stock/add_product_popup.dart';
import 'package:zitoun/pages/stock/add_stock_popup.dart';

import 'package:zitoun/pages/stock/stock_card.dart';
import 'package:zitoun/pages/stock/pigraph.dart';
import 'package:zitoun/db/products.dart';
import 'package:zitoun/pages/dashboard.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double giveTotalStockValue() {
      double total = 0.0;
      for (var price in productTotalPrices) {
        total += price;
      }
      return total;
    }

    double totalStockValue = giveTotalStockValue();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
            children: [
              Text("Stock", style: TextStyle(fontWeight: FontWeight.w300,fontSize: 26)),
              const SizedBox(width: 26),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                  
                ),
                width: 40, 
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.refresh, color: theme.colorScheme.surface),
                  alignment: Alignment.center,
                  onPressed: () async {
                   await loadAllProductsData();
                   SysNotif.showWidget(context,'Stock mis a jour!',Colors.greenAccent,Icons.check);
                   
                   Navigator.push(context,MaterialPageRoute(
                    builder: (_) => DashboardPage(pageIndex: 1), // will correctly open Profile
                  ),);
                  },
                ),
              ),
              
            ],
          ),
            const SizedBox(height: 20),

            // --- GRID SECTION ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: productNames.length,
              itemBuilder: (context, index) {
                return  StockProductCard(title: productNames[index],
                                        quantity: productTotalQuantities[index],
                                        price: productTotalPrices[index],
                                        minQuantity: productMinQuantities[index],
                                        unit: productUnits[index],
                                        icon: productTotalQuantities[index] < productMinQuantities[index] ? Icons.trending_down : Icons.trending_up,
                                        );
              },
            ),

            const SizedBox(height: 24),
            Row(
          children: [
            Text("Nouveau Stock?", style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20)),
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
                      builder: (_) => AddStockPopup(),
                    );
                },
              ),
            ),
            
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text("Ajouter un type de produits", style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20)),
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
                      builder: (_) => AddProductPopup(),
                    );
                },
              ),
            ),
            
          ],
        ),
            const SizedBox(height: 24),
            // --- STATS SECTION ---
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                return Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  children: [
                    // Pie Graph
                    Expanded(
                      flex: 2,
                      child: Container(
                        //height: 180,
                        margin: EdgeInsets.only(
                          right: isMobile ? 0 : 16,
                          bottom: isMobile ? 16 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const PiGraph(),
                      ),
                    ),

                    // Total Value Card
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          //border: BoxBorder.all(color: theme.colorScheme.onSurface,width: 0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              size: 32,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Valeur Financiere du Stock",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme
                                    .primary
                                    .withOpacity(0.7),
                                    fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              child: Text(
                                "${totalStockValue}" + " DH",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.greenAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // --- BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.download),
                label: const Text("Generate Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}