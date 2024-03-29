class AppletWithId {
  List<Data>? data;

  AppletWithId({this.data});

  AppletWithId.fromJson(Map<String, dynamic> json) {
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
  int? runningStatus;
  bool? status;
  List<Areas>? areas;
  int? userId;
  User? user;

  Data(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.runningStatus,
      this.status,
      this.areas,
      this.userId,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    name = json['name'];
    runningStatus = json['running_status'];
    status = json['status'];
    if (json['areas'] != null) {
      areas = <Areas>[];
      json['areas'].forEach((v) {
        areas!.add(new Areas.fromJson(v));
      });
    }
    userId = json['user_id'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['DeletedAt'] = this.deletedAt;
    data['name'] = this.name;
    data['running_status'] = this.runningStatus;
    data['status'] = this.status;
    if (this.areas != null) {
      data['areas'] = this.areas!.map((v) => v.toJson()).toList();
    }
    data['user_id'] = this.userId;
    if (this.user != null) {
      data['User'] = this.user!.toJson();
    }
    return data;
  }
}

class Areas {
  int? iD;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? name;
  String? description;
  bool? isTemplate;
  bool? isAction;
  String? functionName;
  String? config;
  String? params;
  int? appletId;
  int? serviceId;
  Service? service;

  Areas(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.isTemplate,
      this.isAction,
      this.functionName,
      this.config,
      this.params,
      this.appletId,
      this.serviceId,
      this.service});

  Areas.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    name = json['name'];
    description = json['description'];
    isTemplate = json['isTemplate'];
    isAction = json['isAction'];
    functionName = json['function_name'];
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
    data['function_name'] = this.functionName;
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
  String? color;
  String? icon;
  Button? button;

  Service(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.color,
      this.icon,
      this.button});

  Service.fromJson(Map<String, dynamic> json) {
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

class User {
  int? iD;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? avatar;
  String? uuid;

  User(
      {this.iD,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.avatar,
      this.uuid});

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['DeletedAt'] = this.deletedAt;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['avatar'] = this.avatar;
    data['uuid'] = this.uuid;
    return data;
  }
}
