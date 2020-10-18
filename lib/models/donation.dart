class Donation {
  String id;
  String quantity;
  String name;
  String donorName;
  String donorContact;
  String donorAddress;
  String donorID;
  String img;

  Donation({this.donorName, this.name, this.id, this.img, this.quantity, this.donorAddress, this.donorContact, this.donorID});

  Donation.fromMap(Map snapshot, String id):
      id = id ?? '',
      quantity = snapshot['quantity'] ?? '',
      name = snapshot['name'] ?? '',
      donorAddress = snapshot['donorAddress'] ?? '',
      donorContact = snapshot['donorContact'] ?? '',
      donorName = snapshot['donorName'] ?? '',
      donorID = snapshot['donorID'] ?? '',
      img = snapshot['img'] ?? '';

  toJSON() {
    return {
      "name": name,
      "quantity": quantity,
      "img": img,
      "donorName" : donorName,
      "donorContact": donorContact,
      "donorAddress": donorAddress,
      "donorID": donorID,
    };
  }

}