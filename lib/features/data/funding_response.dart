class Funding {
  final String id;
  final String name;
  final String type;
  final String amount;
  final String deadline;
  final String description;
  final List<String> requirements;
  final String website;
  final List<String> fields;
  final List<String> coverage;
  final String color;
  final String criteria;

  Funding({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.deadline,
    required this.description,
    required this.requirements,
    required this.website,
    required this.fields,
    required this.coverage,
    required this.color,
    required this.criteria,
  });

  factory Funding.fromJson(Map<String, dynamic> json) {
    return Funding(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      amount: json['amount'] ?? '',
      deadline: json['deadline'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      website: json['website'] ?? '',
      fields: List<String>.from(json['fields'] ?? []),
      coverage: List<String>.from(json['coverage'] ?? []),
      color: json['color'] ?? '',
      criteria: json['criteria'] ?? '',
    );
  }
}

class FundingResponse {
  final List<Funding> fundingList;

  FundingResponse({required this.fundingList});

  factory FundingResponse.fromJson(Map<String, dynamic> json) {
    return FundingResponse(
      fundingList: (json['fundingList'] as List)
          .map((e) => Funding.fromJson(e))
          .toList(),
    );
  }
}
