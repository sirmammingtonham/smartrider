class Driver {
  String deviceId;
  String name;
  String email;
  String phone;
  bool available;
  String licensePlate;

  Driver(
      {this.deviceId,
      this.name,
      this.email,
      this.phone,
      this.available,
      this.licensePlate});

  Driver.fromDocument(doc) {
    this.deviceId = doc['deviceId'];
    this.name = doc['name'];
    this.email = doc['email'];
    this.phone = doc['phone'];
    this.available = doc['available'];
    this.licensePlate = doc['licensePlate'];
  }
}
