import 'package:flutter/material.dart';
import 'package:zitoun/db/products.dart';
import 'package:zitoun/pages/gestion_stock/gestion_stock.dart';
import 'package:zitoun/pages/home/chart.dart';
import 'package:zitoun/pages/dashboard.dart';
import 'package:zitoun/pages/notifs/system_notif.dart';

const List<String>title=[
  'stock achat',
  'commande',
  'stock achat'
];
const List<String>price=[
  '-5000',
  '+12000',
  '-8000'
];
const List<String>quantity=[
  '250 kg',
  '180 kg',
  '450 kg'
];
const List<Color> colorIcon=[
  Colors.redAccent,
  Colors.greenAccent,
  Colors.redAccent
];
const List<IconData> iconData=[
  Icons.shopping_cart,
  Icons.local_shipping,
  Icons.shopping_cart
];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STOCK
          const StockSection(),
          const SizedBox(height: 40),

          // FINANCE TRACKING
          const FinanceTrackingSection(),
          const SizedBox(height: 40),

          // HISTORIQUE
          HistorySection(icon: iconData,iconData:colorIcon,title:title,price:price,quantity:quantity,),
        ],
      ),
    );
  }
}

class StockSection extends StatelessWidget {
  const StockSection({super.key});
  static  List<String> stockList = productNames.length==0
      ? ['','','','','','']
      : productNames;
  static List<String> stockUnite = productUnits.length==0
      ? ['','','','','','']
      : productUnits;
  static List<double> stockQuantities = productTotalQuantities.length==0
      ? [0,0,0,0,0,0]
      : productTotalQuantities;
  static List<double> stockMinQuantities = productMinQuantities.length==0
      ? [0,0,0,0,0,0]
      : productMinQuantities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
                    builder: (_) => DashboardPage(pageIndex: 0), // will correctly open Profile
                  ),);
                  },
                ),
              ),
              
            ],
          ),
        const SizedBox(height: 20),

        // GRID OF STOCK BOXES
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(
            stockList.length,
            (i) => Container(
              //width: 180,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.cardColor,
                border: Border.all(color: Colors.black12),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title at top left
                  Text(
                    stockList[i],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  
                  // Number with icon at bottom
                  Row(
                    children: [
                    
                      Text(
                        '${stockQuantities[i]} ${stockUnite[i]}', // Your number
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        stockQuantities[i]>stockMinQuantities[i]? Icons.trending_up:Icons.trending_down, // Change to your desired icon
                        size: 30,
                        color: stockQuantities[i]>stockMinQuantities[i]? Colors.greenAccent:Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
        Row(children: [
          IconButton(onPressed: (){Navigator.push(context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(pageIndex: 1), // will correctly open Profile
        ),
        );}, icon: Icon(Icons.arrow_back,color: theme.colorScheme.onSurface,)),
          const SizedBox(width: 10,),
          Text("Voir Stock",style: TextStyle(color: theme.colorScheme.primary),)
        ],),

        const SizedBox(height: 20),
        // Add Stock Button
        Row(
          children: [
            Text("Gestion Stock", style: theme.textTheme.titleLarge),
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
                    builder: (context) => GestionDeStock(context: context,),
                  );
                },
              ),
            ),
            
          ],
        ),
        const SizedBox(height: 20),
        Row(children: [
          Text("Gestion Facture", style: theme.textTheme.titleLarge),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary,
                
              ),
              width: 40,
              child: IconButton(
                icon: Icon(Icons.receipt_long, color: theme.colorScheme.surface),
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(pageIndex: 3,),
                    ),
                  );
                },
              ),
            ),
        ],)
      ],
    );
  }
}

class FinanceTrackingSection extends StatelessWidget {
  const FinanceTrackingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample data
    final usdData = [
      CashFlowData('Apr', 1800),
      CashFlowData('May', 2200),
      CashFlowData('Jun', 2800),
      CashFlowData('Jul', 3400),
      CashFlowData('Aug', 2900),
      CashFlowData('Sep', 3100),
      CashFlowData('Oct', 2700),
      CashFlowData('Nov', 3500),
      CashFlowData('Dec', 3000),
      CashFlowData('Jan', 3600),
      CashFlowData('Feb', 3200),
      CashFlowData('Mar', 3300),
    ];

    final eurData = [
      CashFlowData('Apr', 1500),
      CashFlowData('May', 2000),
      CashFlowData('Jun', 2400),
      CashFlowData('Jul', 3200),
      CashFlowData('Aug', 2600),
      CashFlowData('Sep', 2900),
      CashFlowData('Oct', 3300),
      CashFlowData('Nov', 2800),
      CashFlowData('Dec', 3100),
      CashFlowData('Jan', 3400),
      CashFlowData('Feb', 2900),
      CashFlowData('Mar', 3200),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Finance Tracking",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface, // Dark background for the chart
            border: Border.all(color: Colors.black12),
          ),
          child: CashFlowChart(
            usdData: usdData,
            eurData: eurData,
          ),
        ),
      ],
    );
  }
}

class HistorySection extends StatelessWidget {
  HistorySection({super.key,required this.icon,required this.iconData,required this.title,
  required this.quantity,required this.price});
  final List<IconData> icon;
  final List<Color> iconData;
  final List<String> title;
  final List<String> quantity;
  final List<String> price;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Historique",
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        Column(
          children: List.generate(
            3,
            (i) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.cardColor,
              border: Border.all(color: Colors.black12),
            ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconData[i].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon[i],
                    color: iconData[i],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Date
                Expanded(
                  flex: 2,
                  child: Text(
                    'Dec 06, 2025',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                // Type
                Expanded(
                  flex: 2,
                  child: Text(
                    title[i],
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                
                // Quantity
                Expanded(
                  flex: 1,
                  child: Text(
                    quantity[i],
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Price
                Text(
                  price[i],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: iconData[i],
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
        Row(children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,color: theme.colorScheme.onSurface,)),
          const SizedBox(width: 10,),
          Text("Voir Historique",style: TextStyle(color: theme.colorScheme.primary),)
        ],),
        
      ],
    );
    
  }
}
