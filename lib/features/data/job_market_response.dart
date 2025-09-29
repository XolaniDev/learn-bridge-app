class JobMarketResponse {
  final Map<String, List<JobData>> jobsByCategory;
  final MarketInsights marketInsights;

  JobMarketResponse({
    required this.jobsByCategory,
    required this.marketInsights,
  });

  factory JobMarketResponse.fromJson(Map<String, dynamic> json) {
    final jobsByCategory = <String, List<JobData>>{};
    if (json['jobsByCategory'] != null) {
      (json['jobsByCategory'] as Map<String, dynamic>).forEach((key, value) {
        jobsByCategory[key] =
            (value as List).map((e) => JobData.fromJson(e)).toList();
      });
    }

    return JobMarketResponse(
      jobsByCategory: jobsByCategory,
      marketInsights: MarketInsights.fromJson(json['marketInsights']),
    );
  }
}

class JobData {
  final String title;
  final String industry;
  final String demand;
  final String salary;
  final String growth;
  final String description;
  final List<String> requirements;
  final List<String> companies;
  final String education;
  final List<String> hotspots;

  JobData({
    required this.title,
    required this.industry,
    required this.demand,
    required this.salary,
    required this.growth,
    required this.description,
    required this.requirements,
    required this.companies,
    required this.education,
    required this.hotspots,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      title: json['title'] ?? '',
      industry: json['industry'] ?? '',
      demand: json['demand'] ?? '',
      salary: json['salary'] ?? '',
      growth: json['growth'] ?? '',
      description: json['description'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      companies: List<String>.from(json['companies'] ?? []),
      education: json['education'] ?? '',
      hotspots: List<String>.from(json['hotspots'] ?? []),
    );
  }
}

class MarketInsights {
  final List<SectorGrowth> fastestGrowingSectors;
  final List<String> inDemandSkills;

  MarketInsights({
    required this.fastestGrowingSectors,
    required this.inDemandSkills,
  });

  factory MarketInsights.fromJson(Map<String, dynamic> json) {
    return MarketInsights(
      fastestGrowingSectors: (json['fastestGrowingSectors'] as List)
          .map((e) => SectorGrowth.fromJson(e))
          .toList(),
      inDemandSkills: List<String>.from(json['inDemandSkills'] ?? []),
    );
  }
}

class SectorGrowth {
  final String name;
  final String growth;
  final String jobs;

  SectorGrowth({
    required this.name,
    required this.growth,
    required this.jobs,
  });

  factory SectorGrowth.fromJson(Map<String, dynamic> json) {
    return SectorGrowth(
      name: json['name'] ?? '',
      growth: json['growth'] ?? '',
      jobs: json['jobs'] ?? '',
    );
  }
}
