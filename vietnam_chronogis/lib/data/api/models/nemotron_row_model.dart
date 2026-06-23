class NemotronRowModel {
  final String uuid;
  final String educationLevel;
  final String region;
  final String occupation;
  final int? age;
  final String? sex;

  const NemotronRowModel({
    required this.uuid,
    required this.educationLevel,
    required this.region,
    required this.occupation,
    this.age,
    this.sex,
  });

  factory NemotronRowModel.fromJson(Map<String, dynamic> json) {
    return NemotronRowModel(
      uuid: json['uuid']?.toString() ?? '',
      educationLevel: json['education_level']?.toString() ?? '',
      region: json['region']?.toString() ?? '',
      occupation: json['occupation']?.toString() ?? '',
      age: (json['age'] as num?)?.toInt(),
      sex: json['sex']?.toString(),
    );
  }
}

class EducationStats {
  final String region;
  final int sampleSize;
  final Map<String, int> levelCounts;

  const EducationStats({
    required this.region,
    required this.sampleSize,
    required this.levelCounts,
  });

  double percentFor(String level) {
    if (sampleSize == 0) return 0;
    return (levelCounts[level] ?? 0) * 100 / sampleSize;
  }
}
