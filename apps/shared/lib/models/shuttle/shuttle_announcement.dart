class ShuttleAnnouncement {
  ShuttleAnnouncement({
    this.body,
    this.id,
    this.start,
    this.signature,
    this.scheduleType,
    this.subject,
    this.end,
  });

  ShuttleAnnouncement.fromJson(Map<String, dynamic> json) {
    body = json['body'] as String?;
    id = json['id'] as String?;
    start = json['start'] as String?;
    signature = json['signature'] as String?;
    scheduleType = json['scheduleType'] as String?;
    subject = json['subject'] as String?;
    end = json['end'] as String?;
  }
  String? body;
  String? id;
  String? start;
  String? signature;
  String? scheduleType;
  String? subject;
  String? end;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['body'] = body;
    data['id'] = id;
    data['start'] = start;
    data['signature'] = signature;
    data['scheduleType'] = scheduleType;
    data['subject'] = subject;
    data['end'] = end;
    return data;
  }
}
