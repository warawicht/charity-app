class Request {
  String id;
  String quantity;
  String name;
  String recipientName;
  String recipientContact;
  String recipientAddress;
  String recipientID;
  String description;

  Request({this.description, this.recipientName, this.quantity, this.name, this.id, this.recipientAddress, this.recipientContact, this.recipientID});

  Request.fromMap(Map snapshot, String id):
        id = id ?? '',
        quantity = snapshot['quantity'] ?? '',
        name = snapshot['name'] ?? '',
        recipientName = snapshot['recipientName'] ?? '',
        recipientID = snapshot['recipientID'] ?? '',
        recipientContact = snapshot['recipientContact'] ?? '',
        recipientAddress = snapshot['recipientAddress'] ?? '',
        description = snapshot['description'] ?? '';

  toJSON() {
    return {
      "name": name,
      "quantity": quantity,
      "description": description,
      "recipientName" : recipientName,
      "recipientContact": recipientContact,
      "recipientAddress": recipientAddress,
      "recipientID": recipientID,
    };
  }
}