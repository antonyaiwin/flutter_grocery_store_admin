import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel {
  String? collectionDocumentId;
  String? name;
  String? buildingName;
  String? floor;
  String? decodedAddress;
  double? latitude;
  double? longitude;
  String? landmark;
  String? phoneNumber;
  AddressModel({
    this.collectionDocumentId,
    this.name,
    this.buildingName,
    this.floor,
    this.decodedAddress,
    this.latitude,
    this.longitude,
    this.landmark,
    this.phoneNumber,
  });

  LatLng? getLatLng() {
    if (latitude == null || longitude == null) {
      return null;
    }
    return LatLng(latitude!, longitude!);
  }

  factory AddressModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> ref) {
    return AddressModel.fromMap(ref.data())
        .copyWith(collectionDocumentId: ref.id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'buildingName': buildingName,
      'floor': floor,
      'decodedAddress': decodedAddress,
      'latitude': latitude,
      'longitude': longitude,
      'landmark': landmark,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, dynamic> toMapWithoutNull() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (buildingName != null) 'buildingName': buildingName,
      if (floor != null) 'floor': floor,
      if (decodedAddress != null) 'decodedAddress': decodedAddress,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (landmark != null) 'landmark': landmark,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      name: map['name'] != null ? map['name'] as String : null,
      buildingName:
          map['buildingName'] != null ? map['buildingName'] as String : null,
      floor: map['floor'] != null ? map['floor'] as String : null,
      decodedAddress: map['decodedAddress'] != null
          ? map['decodedAddress'] as String
          : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      landmark: map['landmark'] != null ? map['landmark'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(collectionDocumentId: $collectionDocumentId, name: $name, buildingName: $buildingName, floor: $floor, decodedAddress: $decodedAddress, latitude: $latitude, longitude: $longitude, landmark: $landmark, phoneNumber: $phoneNumber)';
  }

  AddressModel copyWith({
    String? collectionDocumentId,
    String? name,
    String? buildingName,
    String? floor,
    String? decodedAddress,
    double? latitude,
    double? longitude,
    String? landmark,
    String? phoneNumber,
  }) {
    return AddressModel(
      collectionDocumentId: collectionDocumentId ?? this.collectionDocumentId,
      name: name ?? this.name,
      buildingName: buildingName ?? this.buildingName,
      floor: floor ?? this.floor,
      decodedAddress: decodedAddress ?? this.decodedAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      landmark: landmark ?? this.landmark,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
