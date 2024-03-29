class Services {
  List<ServicesData>? data;

  Services({this.data});

  Services.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ServicesData>[];
      json['data'].forEach((v) {
        data!.add(new ServicesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesData {
  int? iD;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? name;
  String? description;
  String? color;
  String? icon;
  Button? button;

  ServicesData(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.color,
      this.icon,
      this.button});

  ServicesData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    name = json['name'];
    description = json['description'];
    color = json['color'];
    icon = json['icon'];
    button =
        json['button'] != null ? new Button.fromJson(json['button']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['DeletedAt'] = this.deletedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = this.color;
    data['icon'] = this.icon;
    if (this.button != null) {
      data['button'] = this.button!.toJson();
    }
    return data;
  }
}

class Button {
  String? provider;
  String? clientId;
  String? redirectUri;
  String? auth;
  String? scopes;

  Button(
      {this.provider, this.clientId, this.redirectUri, this.auth, this.scopes});

  Button.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    clientId = json['client_id'];
    redirectUri = json['redirect_uri'];
    auth = json['auth'];
    scopes = json['scopes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['client_id'] = this.clientId;
    data['redirect_uri'] = this.redirectUri;
    data['auth'] = this.auth;
    data['scopes'] = this.scopes;
    return data;
  }
}
