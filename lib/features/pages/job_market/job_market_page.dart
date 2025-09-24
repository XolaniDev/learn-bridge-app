import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/data/profile/user_profile.dart';

class JobMarketPage extends StatefulWidget {
  final VoidCallback onBack;

  const JobMarketPage({super.key, required this.onBack, required UserProfile userProfile});

  @override
  State<JobMarketPage> createState() => _JobMarketPageState();
}

class _JobMarketPageState extends State<JobMarketPage> {
  String searchTerm = "";
  String selectedCategory = "All";
  String? expandedJobId;

  final List<String> jobCategories = [
    'All',
    'Technology',
    'Engineering',
    'Finance',
    'Healthcare',
    'Education'
  ];

  final List<Map<String, dynamic>> trendingJobs = [
    {
      "id": "1",
      "title": "Software Developer",
      "category": "Technology",
      "description": "Design, develop and maintain software applications and systems",
      "demand": "Very High",
      "avgSalary": "R35,000 - R85,000",
      "growth": "+15%",
      "location": "Cape Town, Johannesburg, Durban",
      "skills": ["Python", "JavaScript", "React", "Problem Solving"],
      "education": ["Computer Science", "Software Engineering", "Information Technology"],
      "experience": "Entry to Senior Level",
      "companies": ["Capitec", "Discovery", "Takealot", "BCX"],
      "icon": "💻"
    },
    {
      "id": "2",
      "title": "Data Scientist",
      "category": "Technology",
      "description": "Analyze complex data to help organizations make data-driven decisions",
      "demand": "Very High",
      "avgSalary": "R40,000 - R100,000",
      "growth": "+22%",
      "location": "Johannesburg, Cape Town",
      "skills": ["Python", "R", "Machine Learning", "Statistics"],
      "education": ["Computer Science", "Statistics", "Mathematics", "Data Science"],
      "experience": "Mid to Senior Level",
      "companies": ["Standard Bank", "Vodacom", "MTN", "Old Mutual"],
      "icon": "📊"
    },
    {
      "id": "3",
      "title": "Renewable Energy Engineer",
      "category": "Engineering",
      "description": "Design and implement sustainable energy solutions",
      "demand": "High",
      "avgSalary": "R45,000 - R95,000",
      "growth": "+18%",
      "location": "Cape Town, Port Elizabeth",
      "skills": ["Solar Design", "Wind Energy", "Project Management", "AutoCAD"],
      "education": ["Electrical Engineering", "Mechanical Engineering", "Energy Systems"],
      "experience": "Entry to Senior Level",
      "companies": ["Eskom", "Sasol", "BioTherm Energy", "Red Cap Energy"],
      "icon": "⚡"
    },
    {
      "id": "4",
      "title": "Digital Marketing Specialist",
      "category": "Technology",
      "description": "Create and manage digital marketing campaigns across platforms",
      "demand": "High",
      "avgSalary": "R25,000 - R55,000",
      "growth": "+12%",
      "location": "Johannesburg, Cape Town, Durban",
      "skills": ["SEO", "Social Media", "Google Ads", "Analytics"],
      "education": ["Marketing", "Communications", "Business Studies"],
      "experience": "Entry to Mid Level",
      "companies": ["Ogilvy", "FCB", "Quirk", "King James"],
      "icon": "📱"
    },
    {
      "id": "5",
      "title": "Financial Analyst",
      "category": "Finance",
      "description": "Analyze financial data to guide business investment decisions",
      "demand": "High",
      "avgSalary": "R30,000 - R70,000",
      "growth": "+8%",
      "location": "Johannesburg, Cape Town",
      "skills": ["Excel", "Financial Modeling", "SQL", "PowerBI"],
      "education": ["Finance", "Accounting", "Economics", "BCom"],
      "experience": "Entry to Senior Level",
      "companies": ["FirstRand", "Nedbank", "Investec", "Old Mutual"],
      "icon": "💰"
    },
    {
      "id": "6",
      "title": "Cybersecurity Specialist",
      "category": "Technology",
      "description": "Protect organizations from cyber threats and security breaches",
      "demand": "Very High",
      "avgSalary": "R50,000 - R120,000",
      "growth": "+25%",
      "location": "Johannesburg, Cape Town",
      "skills": ["Network Security", "Ethical Hacking", "Risk Assessment", "Compliance"],
      "education": ["Computer Science", "Information Security", "IT"],
      "experience": "Mid to Senior Level",
      "companies": ["Dimension Data", "Sekuro", "EOH", "Telkom"],
      "icon": "🔒"
    }
  ];

  Color getDemandColor(String demand) {
    switch (demand) {
      case 'Very High':
        return Colors.green;
      case 'High':
        return Colors.blue;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color getGrowthColor(String growth) {
    final percent = int.tryParse(growth.replaceAll('%', '').replaceAll('+', '')) ?? 0;
    if (percent >= 20) return Colors.green;
    if (percent >= 10) return Colors.blue;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = trendingJobs.where((job) {
      final matchesSearch = job["title"].toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
          job["description"].toString().toLowerCase().contains(searchTerm.toLowerCase()) ||
          (job["skills"] as List).any((s) => s.toLowerCase().contains(searchTerm.toLowerCase()));

      final matchesCategory = selectedCategory == "All" || job["category"] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBack,
        ),
        title: const Text("Job Market Trends", style: TextStyle(color: Colors.black)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => setState(() => searchTerm = val),
              decoration: InputDecoration(
                hintText: "Search jobs or skills...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: jobCategories.map((cat) {
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Market Overview
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(children: [
                    Text("6.2M", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text("Total Jobs")
                  ]),
                  Column(children: [
                    Text("+12%", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text("Growth Rate")
                  ]),
                  Column(children: [
                    Text("85%", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
                    Text("Tech Demand")
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Job Listings
          ...filteredJobs.map((job) {
            final isExpanded = expandedJobId == job["id"];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job["icon"], style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(job["description"], style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(job["demand"]),
                                backgroundColor: getDemandColor(job["demand"]).withOpacity(0.1),
                                labelStyle: TextStyle(color: getDemandColor(job["demand"])),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Salary + Growth
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("💰 ${job["avgSalary"]}"),
                        Text("${job["growth"]} growth", style: TextStyle(color: getGrowthColor(job["growth"]))),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location + Expand
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("📍 ${job["location"].toString().split(",")[0]}"),
                        TextButton(
                          onPressed: () => setState(() => expandedJobId = isExpanded ? null : job["id"]),
                          child: Text(isExpanded ? "Less Details" : "More Details"),
                        ),
                      ],
                    ),

                    if (isExpanded) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      Text("Skills Required:", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 6,
                        children: (job["skills"] as List).map((s) => Chip(label: Text(s))).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text("Education Pathways:", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 6,
                        children: (job["education"] as List).map((e) => Chip(label: Text(e))).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text("Experience Level: ${job["experience"]}"),
                      Text("Top Employers: ${(job["companies"] as List).join(', ')}"),
                      Text("Key Locations: ${job["location"]}"),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(onPressed: () {}, child: const Text("Find Related Courses")),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(onPressed: () {}, child: const Text("Save Career Path")),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            );
          }).toList(),

          if (filteredJobs.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: const [
                    Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("No jobs found", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Try adjusting your search or category filter", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Career Growth Tips
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Career Growth Tips", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("• Technology skills are in highest demand across all industries"),
                  Text("• Consider hybrid roles that combine your interests with tech"),
                  Text("• Continuous learning and certifications boost earning potential"),
                  Text("• Remote work opportunities are expanding rapidly"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
