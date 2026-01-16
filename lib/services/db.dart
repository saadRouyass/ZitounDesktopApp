import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zitoun/db/clients.dart';
import 'package:zitoun/db/products.dart';
import 'package:flutter/foundation.dart';

final serverUrl = dotenv.env['URL']??'http://localhost:3000';

Future<bool> signIn(String email, String password) async {
  final url = Uri.parse(serverUrl + '/signin');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // expects: { success: true/false }
    return data['success'] == true;
  } else {
    return false;
  }
}

Future<bool> signUp(String email, String password,String firstname,String lastname,
 String phonenumber) async {
  final url = Uri.parse(serverUrl + '/signup');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'email': email,
      'password': password,
      'firstname':firstname,
      'lastname':lastname,
      'phonenumber':phonenumber
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // expects: { success: true/false }
    return data['success'] == true;
  } else {
    return false;
  }
}

//to get totals of a specific product type
Future<Map<String, dynamic>> fetchTotals(

   String productType
) async {
  final response = await http.post(
    Uri.parse(serverUrl + '/db/totals'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'type': productType,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Request failed: ${response.statusCode}');
  }

  final decoded = jsonDecode(response.body) as Map<String, dynamic>;

  if (decoded['success'] != true) {
    throw Exception('API returned success=false');
  }

  return decoded['totals'] as Map<String, dynamic>;
}

//to get all the element in a table 
Future<List<ProductType>> fetchProductTypes(String table) async {
  final response = await http.get(
    Uri.parse(serverUrl + '/db/$table'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load products');
  }

  final decoded = jsonDecode(response.body) as Map<String, dynamic>;

  if (decoded['success'] != true) {
    throw Exception('API returned success=false');
  }

  final List data = decoded['data'];

  return data
      .map((item) => ProductType.fromJson(item))
      .toList();
}

Future<List<ProductsHistory>> fetchProductHistory() async {
  final response = await http.get(
    Uri.parse(serverUrl + '/db/productshistory'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load data');
  }

  final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

  return parseProductHistory(jsonResponse);
}

Future<void> insertProduct({
  required String productName,
  required double unitPrice,
  required String unit,
  required double minQuantity,
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertProduct'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'productName': productName,
      'unitPrice': unitPrice,
      'unit': unit,
      'minQuantity': minQuantity,
    }),
  );

  final decoded = jsonDecode(response.body);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product failed');
  }
}

Future<void> insertProductHistory({
  required DateTime date,
  required double quantity,
  required double price,
  required String productType,
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertProductHistory'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'date': date.toIso8601String(), // important
      'quantity': quantity,
      'price': price,
      'productType': productType,
    }),
  );

  final decoded = jsonDecode(response.body);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<List<Client>> fetchClients() async {
  final response = await http.get(
    Uri.parse(serverUrl + '/db/clients'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load data');
  }

  final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

  return parseClients(jsonResponse);
}

Future<void> insertOliveN({
  required DateTime date,
  required double boites,
  required double price,
  required double cartonQuantity,
  required double cartonPrice,
  required double lessieurQuantity,
  required double lessieurPrice
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertOliveN'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'date': date.toIso8601String(), // important
      'boites': boites,
      'price': price,
      'cartonQuantity': cartonQuantity,
      'priceCarton': cartonPrice,
      'lessieurQuantity': lessieurQuantity,
      'priceLessieur' : lessieurPrice
    }),
  );

  final decoded = jsonDecode(response.body);
  print(decoded);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<void> insertOliveH({
  required DateTime date,
  required double boites,
  required double price,
  required double cartonQuantity,
  required double cartonPrice,
  required double lessieurQuantity,
  required double lessieurPrice,
  required double za3tarQuantity,
  required double za3tarPrice,
  required double hrissaQuantity,
  required double hrissaPrice
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertOliveH'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'date': date.toIso8601String(), // important
      'boites': boites,
      'price': price,
      'cartonQuantity': cartonQuantity,
      'priceCarton': cartonPrice,
      'lessieurQuantity': lessieurQuantity,
      'priceLessieur' : lessieurPrice,
      'za3tarQuantity' : za3tarQuantity,
      'za3tarPrice': za3tarPrice,
      'hrissaQuantity': hrissaQuantity,
      'hrissaPrice':hrissaPrice
    }),
  );

  final decoded = jsonDecode(response.body);
  print(decoded);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<void> insertOliveM({
  required DateTime date,
  required double boites,
  required double price,
  required double cartonQuantity,
  required double cartonPrice,
  required double lessieurQuantity,
  required double lessieurPrice,
  required double za3tarQuantity,
  required double za3tarPrice,
  required double citronQuantity,
  required double citronPrice
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertOliveM'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'date': date.toIso8601String(), // important
      'boites': boites,
      'price': price,
      'cartonQuantity': cartonQuantity,
      'priceCarton': cartonPrice,
      'lessieurQuantity': lessieurQuantity,
      'priceLessieur' : lessieurPrice,
      'za3tarQuantity' : za3tarQuantity,
      'za3tarPrice': za3tarPrice,
      'citronQuantity': citronQuantity,
      'citronPrice':citronPrice
    }),
  );

  final decoded = jsonDecode(response.body);
  print(decoded);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<void> insertOliveS({
  required DateTime date,
  required double boites,
  required double price,
  required double cartonQuantity,
  required double cartonPrice
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertOliveS'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'date': date.toIso8601String(), // important
      'boites': boites,
      'price': price,
      'cartonQuantity': cartonQuantity,
      'priceCarton': cartonPrice
    }),
  );

  final decoded = jsonDecode(response.body);
  print(decoded);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<void> insertRessource({
  required DateTime date,
  required String ressourceType,
  required double quantity,
  required double price
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertRessource'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'date': date.toIso8601String(), // important
      'ressourceType': ressourceType,
      'quantity': quantity,
      'price': price
    }),
  );

  final decoded = jsonDecode(response.body);
  print(decoded);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<void> insertClient({
  required String address,
  required String email,
  required String phonenumber,
  required String city,
}) async {
  final response = await http.post(
    Uri.parse('$serverUrl/db/insertClient'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'address': address, // important
      'email': email,
      'phone': phonenumber,
      'city': city
    }),
  );

  final decoded = jsonDecode(response.body);
  print(decoded);

  if (response.statusCode != 200 || decoded['success'] != true) {
    throw Exception(decoded['message'] ?? 'Insert product history failed');
  }
}

Future<void> substractItems(items) async {
  final url = Uri.parse('$serverUrl/db/substractItems');

  final body = jsonEncode({
    "items": items,
  });

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Items substracted successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed: ${response.statusCode}');
        print(response.body);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error sending items: $e');
    }
  }
}
