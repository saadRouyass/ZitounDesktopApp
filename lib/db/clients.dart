import 'package:zitoun/services/db.dart';

class Client {
  final int id;
  final String name;

  final String email;
  final String phonenumber;
  final String location;
  final String city;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phonenumber,
    required this.location,
    required this.city
  });
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ,
      name: json['name'] as String,
      email: json['email'] as String,
      phonenumber: json['phonenumber'] as String, 
      location: json['location'] as String,
      city: json['city'] as String,
    );
  }
}

List<Client> parseClients(Map<String, dynamic> response) {
  final List<dynamic> data = response['data'];

  return data
      .map((item) => Client.fromJson(item))
      .toList();
}

List<Client> clients = [];
List<String> clientsNames = [];

Future<void> loadClientsNames() async {
  clientsNames.clear();
  
  for(final client in clients){
    clientsNames.add(client.name);
  }
  
  
}

Future<void> loadClients() async {
  clients.clear();
  final fetchedClients = await fetchClients();
  clients.addAll(fetchedClients);
  await loadClientsNames();
  
  
}




