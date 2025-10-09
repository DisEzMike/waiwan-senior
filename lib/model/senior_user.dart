import 'package:waiwan/utils/config.dart';

class SeniorUser {
  final String id;
  final String displayName;
  final SeniorUserProfile profile;
  final SeniorUserAbility? ability;

  SeniorUser({
    required this.id,
    required this.displayName,
    required this.profile,
    required this.ability,
  });

  factory SeniorUser.fromJson(Map<String, dynamic> json) {
    return SeniorUser(
      id: json['user']['id'] ?? '',
      displayName: json['user']['displayname'] ?? '',
      profile: SeniorUserProfile.fromJson(json['profile']),
      ability: SeniorUserAbility.fromJson(json['ability']),
    );
  }
}

class SeniorUserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String id_card;
  final String id_address;
  final String current_address;
  final String gender;
  final String phone;
  final String chronic_diseases;
  final String contact_person;
  final String contact_phone;
  final String? imageUrl;

  SeniorUserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.id_card,
    required this.id_address,
    required this.current_address,
    required this.phone,
    required this.gender,
    required this.chronic_diseases,
    required this.contact_person,
    required this.contact_phone,
    required this.imageUrl,
  });

  factory SeniorUserProfile.fromJson(Map<String, dynamic> json) {
    if (json['image_url'] != null) {
      json['image_url'] = API_URL + json['image_url'];
    } else {
      json['image_url'] = 'https://placehold.co/600x400.png';
    }
    return SeniorUserProfile(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      id_card: json['id_card'] ?? '',
      id_address: json['id_address'] ?? '',
      current_address: json['current_address'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      chronic_diseases: json['chronic_diseases'] ?? '',
      contact_person: json['contact_person'] ?? '',
      contact_phone: json['contact_phone'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

class SeniorUserAbility {
  final String id;
  final int type;
  final String work_experience;
  final String other_ability;
  final bool vehicle;
  final bool offsite_work;

  SeniorUserAbility({
    required this.id,
    required this.type,
    required this.work_experience,
    required this.other_ability,
    required this.vehicle,
    required this.offsite_work,
  });

  factory SeniorUserAbility.fromJson(Map<String, dynamic> json) {
    return SeniorUserAbility(
      id: json['id'] ?? '',
      type: json['type'] ?? 0,
      work_experience: json['work_experience'] ?? '',
      other_ability: json['other_ability'] ?? '',
      vehicle: json['vehicle'] ?? false,
      offsite_work: json['offsite_work'] ?? false,
    );
  }
}
