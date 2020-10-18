class Recipient {
  String id;
  String name;
  String contact;
  String address;

  Recipient({this.name, this.id, this.address, this.contact});

  Recipient.fromMap(Map snapshot) :
        id = snapshot['id'] ?? '',
        name = snapshot['name'] ?? '',
        contact = snapshot['contact'] ?? '',
        address = snapshot['address'] ?? '';

  toJSON() {
    return {
      "id" : id,
      "name": name,
      "contact": contact,
      "address": address,
    };
  }
}