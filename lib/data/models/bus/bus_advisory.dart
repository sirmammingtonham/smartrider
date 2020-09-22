// probably need to modify
class BusAdvisory {
  String nid;
  String title;
  String created;
  String changed;
  String type;
  String webUrl;
  List<Body> body;
  String dueTo;
  String status;
  List<String> routes;

  BusAdvisory(
      {this.nid,
      this.title,
      this.created,
      this.changed,
      this.type,
      this.webUrl,
      this.body,
      this.dueTo,
      this.status,
      this.routes});

  BusAdvisory.fromJson(Map<String, dynamic> json) {
    nid = json['nid'];
    title = json['title'];
    created = json['created'];
    changed = json['changed'];
    type = json['type'];
    webUrl = json['webUrl'];
    if (json['body'] != null) {
      body = new List<Body>();
      json['body'].forEach((v) {
        body.add(new Body.fromJson(v));
      });
    }
    dueTo = json['due_to'];
    status = json['status'];
    routes = json['routes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nid'] = this.nid;
    data['title'] = this.title;
    data['created'] = this.created;
    data['changed'] = this.changed;
    data['type'] = this.type;
    data['webUrl'] = this.webUrl;
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    data['due_to'] = this.dueTo;
    data['status'] = this.status;
    data['routes'] = this.routes;
    return data;
  }
}

class Body {
  Rendered rendered;
  Raw raw;

  Body({this.rendered, this.raw});

  Body.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'] != null
        ? new Rendered.fromJson(json['rendered'])
        : null;
    raw = json['raw'] != null ? new Raw.fromJson(json['raw']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rendered != null) {
      data['rendered'] = this.rendered.toJson();
    }
    if (this.raw != null) {
      data['raw'] = this.raw.toJson();
    }
    return data;
  }
}

class Rendered {
  String markup;
  bool access;

  Rendered({this.markup, this.access});

  Rendered.fromJson(Map<String, dynamic> json) {
    markup = json['#markup'];
    access = json['#access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['#markup'] = this.markup;
    data['#access'] = this.access;
    return data;
  }
}

class Raw {
  String value;
  String summary;
  String format;
  String safeValue;
  String safeSummary;

  Raw(
      {this.value,
      this.summary,
      this.format,
      this.safeValue,
      this.safeSummary});

  Raw.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    summary = json['summary'];
    format = json['format'];
    safeValue = json['safe_value'];
    safeSummary = json['safe_summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['summary'] = this.summary;
    data['format'] = this.format;
    data['safe_value'] = this.safeValue;
    data['safe_summary'] = this.safeSummary;
    return data;
  }
}
