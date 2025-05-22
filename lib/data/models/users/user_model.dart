class UserModel {
  bool? success;
  String? message;
  String? accessToken;
  UserDetails? userDetails;

  UserModel({
    this.success,
    this.message,
    this.accessToken,
    this.userDetails,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'],
      message: json['message'],
      accessToken: json['access_token'],
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'access_token': accessToken,
      'user_details': userDetails?.toJson(),
    };
  }
}

class UserDetails {
  int? id;
  String? name;
  String? email;
  String? password;
  String? companyId;
  String? phone;
  String? address;
  String? category;
  String? userImage;
  String? userRole;
  String? userStatus;
  List<UserPriviledges>? userPriviledges;
  String? userBranch;
  String? appUrl;
  String? country;
  String? state;
  String? city;
  String? language;
  String? zipCode;

  UserDetails({
    this.id,
    this.name,
    this.email,
    this.password,
    this.companyId,
    this.phone,
    this.address,
    this.category,
    this.userImage,
    this.userRole,
    this.userStatus,
    this.userPriviledges,
    this.userBranch,
    this.appUrl,
    this.country,
    this.state,
    this.city,
    this.language,
    this.zipCode,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      companyId: json['company_id'],
      phone: json['phone'],
      address: json['address'],
      category: json['category'],
      userImage: json['user_image'],
      userRole: json['user_role'],
      userStatus: json['user_status'],
      userPriviledges: (json['user_priviledges'] as List?)
          ?.map((e) => UserPriviledges.fromJson(e))
          .toList(),
      userBranch: json['user_branch'],
      appUrl: json['app_url'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      language: json['language'],
      zipCode: json['zip_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'company_id': companyId,
      'phone': phone,
      'address': address,
      'category': category,
      'user_image': userImage,
      'user_role': userRole,
      'user_status': userStatus,
      'user_priviledges': userPriviledges?.map((e) => e.toJson()).toList(),
      'user_branch': userBranch,
      'app_url': appUrl,
      'country': country,
      'state': state,
      'city': city,
      'language': language,
      'zip_code': zipCode,
    };
  }
}

class UserPriviledges {
  String? screen;
  String? id;
  Options? options;

  UserPriviledges({this.screen, this.id, this.options});

  factory UserPriviledges.fromJson(Map<String, dynamic> json) {
    return UserPriviledges(
      screen: json['screen'],
      id: json['id'],
      options: json['options'] != null
          ? Options.fromJson(json['options'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screen': screen,
      'id': id,
      'options': options?.toJson(),
    };
  }
}

class Options {
  String? add;
  String? edit;
  String? delete;

  Options({this.add, this.edit, this.delete});

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      add: json['add'],
      edit: json['edit'],
      delete: json['delete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'add': add,
      'edit': edit,
      'delete': delete,
    };
  }
}
