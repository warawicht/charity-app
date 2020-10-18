class Donor {
  String id;
  String name;
  String contact;
  String address;

  Donor({this.name, this.id, this.address, this.contact});

  Donor.fromMap(Map snapshot) :
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