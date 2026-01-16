import 'package:zitoun/services/db.dart';

//Class to hold product data
class ProductType {

  final double id;
  final String productType;
  final double unitPrice;
  final String unite;
  final double minQuantity;

  ProductType({
    required this.id,
    required this.productType,
    required this.unitPrice,
    required this.unite,
    required this.minQuantity,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
  return ProductType(
    id: (json['id'] as num).toDouble(),
    productType: json['productName'] as String,
    unitPrice: (json['unitPrice'] as num).toDouble(),
    unite: json['unit'] as String,
    minQuantity: (json['minQuantity'] as num).toDouble(),
  );
}

}

class ProductsHistory {

  final double id;
  final String productType;
  final DateTime date;
  final double quantity;
  final double price;

  ProductsHistory({
    required this.id,
    required this.productType,
    required this.date,
    required this.quantity,
    required this.price,
  });

  factory ProductsHistory.fromJson(Map<String, dynamic> json) {
    return ProductsHistory(
      id: (json['id'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      productType: json['producttype'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['prix'] as num).toDouble(),
    );
  }

  
}

List<ProductType> products = [];
List<String> productNames = [];
List<String> productUnits = [];
List<double> productUnitPrices = [];
List<double> productMinQuantities = [];

List<double> productTotalQuantities = [];
List<double> productTotalPrices = [];

List<ProductsHistory> productsHistory = [];
double totalStockValue = 0.0;



Future<void> loadProducts() async {
     
  final fetchedProducts = await fetchProductTypes('products');
  products.clear();
  products.addAll(fetchedProducts);
  
}

List<ProductsHistory> parseProductHistory(Map<String, dynamic> response) {
  final List<dynamic> data = response['data'];

  return data
      .map((item) => ProductsHistory.fromJson(item))
      .toList();
}


Future<void> loadProductNames() async {
  productNames.clear();
  for (final product in products) {
    
    productNames.add(product.productType);
  }
}

Future<void> loadProductUnits() async{
  productUnits.clear();
  for (final product in products) {
    
    productUnits.add(product.unite);
  }
}

Future<void> loadProductUnitPrices() async{
  productUnitPrices.clear();
  for (final product in products) {
    
    productUnitPrices.add(product.unitPrice);
  }
}

Future<void> loadProductMinQuantities() async{
  productMinQuantities.clear();
  for (final product in products) {
    productMinQuantities.add(product.minQuantity);
  }
}

Future<void> loadTotals() async {
  productTotalQuantities.clear();
  productTotalPrices.clear();
  for (final product in products) {
    final res  = await fetchTotals(product.productType);
    productTotalQuantities.add((res['totalQuantity'] as num).toDouble());
    productTotalPrices.add((res['totalPrice'] as num).toDouble());
  }
}

Future<void> loadTotalStockValue() async {
  totalStockValue = 0.0;
  for (final price in productTotalPrices) {
    totalStockValue += price;
  }
}

Future<void> loadProductsHistory() async {
  productsHistory.clear();
  final fetchedHistory = await fetchProductHistory();
  for (final history in fetchedHistory) {
    productsHistory.add(history);
  }
}

Future<void> loadAllProductsData() async {
  await loadProducts();

  await loadProductsHistory();

  await loadProductNames();
  await loadProductUnits();
  await loadProductUnitPrices();
  await loadProductMinQuantities();
  await loadTotals();
  await loadTotalStockValue();
}

