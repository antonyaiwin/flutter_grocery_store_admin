import 'dart:convert';

class UserDataModel {
  String? defaultAddressId;
  String? email;
  String? profileImageUrl;
  String? phoneNumber;
  UserDataModel(
    this.defaultAddressId,
    this.email,
    this.profileImageUrl,
    this.phoneNumber,
  );

  UserDataModel copyWith({
    String? defaultAddressId,
    String? email,
    String? profileImageUrl,
    String? phoneNumber,
    List<String>? recentSearches,
  }) {
    return UserDataModel(
      defaultAddressId ?? this.defaultAddressId,
      email ?? this.email,
      profileImageUrl ?? this.profileImageUrl,
      phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'defaultAddressId': defaultAddressId,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      map['defaultAddressId'] != null
          ? map['defaultAddressId'] as String
          : null,
      map['email'] != null ? map['email'] as String : null,
      map['profileImageUrl'] != null ? map['profileImageUrl'] as String : null,
      map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDataModel(defaultAddressId: $defaultAddressId, email: $email, profileImageUrl: $profileImageUrl, phoneNumber: $phoneNumber)';
  }
}
