class Applet {
  List<Data>? data;

  Applet({this.data});

  Applet.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? iD;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? name;
  String? description;
  bool? isTemplate;
  bool? isAction;
  String? config;
  String? params;
  int? appletId;
  int? serviceId;
  Service? service;

  Data(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.isTemplate,
      this.isAction,
      this.config,
      this.params,
      this.appletId,
      this.serviceId,
      this.service});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    name = json['name'];
    description = json['description'];
    isTemplate = json['isTemplate'];
    isAction = json['isAction'];
    config = json['config'];
    params = json['params'];
    appletId = json['applet_id'];
    serviceId = json['service_id'];
    service =
        json['Service'] != null ? new Service.fromJson(json['Service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['DeletedAt'] = this.deletedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isTemplate'] = this.isTemplate;
    data['isAction'] = this.isAction;
    data['config'] = this.config;
    data['params'] = this.params;
    data['applet_id'] = this.appletId;
    data['service_id'] = this.serviceId;
    if (this.service != null) {
      data['Service'] = this.service!.toJson();
    }
    return data;
  }
}

class Service {
  int? iD;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? name;
  String? description;
  String? icon;

  Service(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.icon});

  Service.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['DeletedAt'] = this.deletedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['icon'] = this.icon;
    return data;
  }
}
