class BusAgency {
  String agencyId;
  String agencyName;
  String agencyUrl;
  String agencyTimezone;
  String agencyLang;
  String agencyPhone;
  String agencyFareUrl;
  String agencyEmail;

  BusAgency({
    this.agencyId,
    this.agencyName,
    this.agencyUrl,
    this.agencyTimezone,
    this.agencyLang,
    this.agencyPhone,
    this.agencyFareUrl,
    this.agencyEmail
  });

  BusAgency.fromString(String raw) {
    print(raw);
    List data = raw.split('\n').toList()[1].split(',').toList();
    agencyId = data[0];
    agencyName = data[1];
    agencyUrl = data[2];
    agencyTimezone = data[3];
    agencyLang = data[4];
    agencyPhone = data[5];
    agencyFareUrl = data[6];
    agencyEmail = data[7];
  }

  String toString() {
    String data = '';
    data += agencyId + ',';
    data += agencyName + ',';
    data += agencyUrl + ',';
    data += agencyTimezone + ',';
    data += agencyLang + ',';
    data += agencyPhone + ',';
    data += agencyFareUrl + ',';
    data += agencyEmail;

    return data;
  }
}