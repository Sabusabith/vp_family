class Person {
  final String? id;
  final String name;
  final int age;
  final String place;
  final String? fatherId;
  final String? motherId;
  final String? spouseId;
  final String photoUrl;
  final String? whatsappNumber; // ← new field

  Person({
    this.id,
    required this.name,
    required this.age,
    required this.place,
    this.fatherId,
    this.motherId,
    this.spouseId,
    required this.photoUrl,
    this.whatsappNumber,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String?,
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      place: json['place'] ?? '',
      fatherId: json['father_id'],
      motherId: json['mother_id'],
      spouseId: json['spouse_id'],
      photoUrl: json['photo_url'] ?? '',
      whatsappNumber: json['whatsapp_number'], // ← new field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'place': place,
      'father_id': fatherId,
      'mother_id': motherId,
      'spouse_id': spouseId,
      'photo_url': photoUrl,
      'whatsapp_number': whatsappNumber, // ← new field
    };
  }
}
