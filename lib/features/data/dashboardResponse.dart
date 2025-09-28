class DashboardResponse {
  final int subjects;
  final int interests;
  final int matches;
  final List<RecommendedCourse> recommendedCourses;
  final List<JobTrend> jobTrends;
  final List<FundingOpportunity> fundingOpportunities;

  DashboardResponse({
    required this.subjects,
    required this.interests,
    required this.matches,
    required this.recommendedCourses,
    required this.jobTrends,
    required this.fundingOpportunities,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      subjects: json['subjects'] ?? 0,
      interests: json['interests'] ?? 0,
      matches: json['matches'] ?? 0,
      recommendedCourses: (json['recommendedCourses'] as List<dynamic>)
          .map((e) => RecommendedCourse.fromJson(e))
          .toList(),
      jobTrends: (json['jobTrends'] as List<dynamic>)
          .map((e) => JobTrend.fromJson(e))
          .toList(),
      fundingOpportunities: (json['fundingOpportunities'] as List<dynamic>)
          .map((e) => FundingOpportunity.fromJson(e))
          .toList(),
    );
  }
}

class RecommendedCourse {
  final String id;
  final String name;
  final String description;
  final List<String> requiredSubjects;
  final String university;
  final String duration;
  final String qualification;

  RecommendedCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredSubjects,
    required this.university,
    required this.duration,
    required this.qualification,
  });

  factory RecommendedCourse.fromJson(Map<String, dynamic> json) {
    return RecommendedCourse(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      requiredSubjects:
      (json['requiredSubjects'] as List<dynamic>).map((e) => e as String).toList(),
      university: json['university'],
      duration: json['duration'],
      qualification: json['qualification'],
    );
  }
}

class JobTrend {
  final String title;
  final String demand;
  final String salary;

  JobTrend({
    required this.title,
    required this.demand,
    required this.salary,
  });

  factory JobTrend.fromJson(Map<String, dynamic> json) {
    return JobTrend(
      title: json['title'],
      demand: json['demand'],
      salary: json['salary'],
    );
  }
}

class FundingOpportunity {
  final String name;
  final String type;
  final String amount;

  FundingOpportunity({
    required this.name,
    required this.type,
    required this.amount,
  });

  factory FundingOpportunity.fromJson(Map<String, dynamic> json) {
    return FundingOpportunity(
      name: json['name'],
      type: json['type'],
      amount: json['amount'],
    );
  }
}
