import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/data/job_market_response.dart';
import '../../service/service.dart';
import 'package:learn_bridge_v2/features/data/user_response.dart';

class JobMarketPage extends StatefulWidget {
  final VoidCallback onBack;
  final UserResponse? userProfile;

  const JobMarketPage({
    super.key,
    required this.onBack,
    required this.userProfile,
  });

  @override
  State<JobMarketPage> createState() => _JobMarketPageState();
}

class _JobMarketPageState extends State<JobMarketPage> {
  final Service _service = Service();

  JobMarketResponse? jobMarketData;
  bool isLoading = true;
  String? errorMessage;

  String selectedCategory = "All";
  String? expandedJobId;

  final List<String> jobCategories = [
    "All",
    "Technology",
    "Engineering",
    "Finance",
    "Healthcare",
    "Education",
  ];

  @override
  void initState() {
    super.initState();
    _fetchJobMarketData();
  }

  Future<void> _fetchJobMarketData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _service.getJobMarketData();

      setState(() {
        jobMarketData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load job market data.";
        isLoading = false;
      });
    }
  }

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // ✅ fixed back navigation
        ),
        title: const Text("Job Market Trends", style: TextStyle(color: Colors.black)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final allJobs = jobMarketData?.jobsByCategory.values.expand((jobs) => jobs).toList() ?? [];
    final filteredJobs = selectedCategory == "All"
        ? allJobs
        : allJobs.where((job) => job.industry == selectedCategory).toList();

    return ListView(
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

        // ✅ Market Insights
        if (jobMarketData?.marketInsights != null)
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Market Insights", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: jobMarketData!.marketInsights.fastestGrowingSectors.map((sector) {
                      return Column(
                        children: [
                          Text(sector.growth,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(sector.name),
                          Text(sector.jobs, style: const TextStyle(color: Colors.grey)),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    children: jobMarketData!.marketInsights.inDemandSkills
                        .map((skill) => Chip(label: Text(skill)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Job Listings
        ...filteredJobs.map((job) {
          final isExpanded = expandedJobId == job.title;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(job.description, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(job.demand),
                    backgroundColor: getDemandColor(job.demand).withOpacity(0.1),
                    labelStyle: TextStyle(color: getDemandColor(job.demand)),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "💰 ${job.salary}",
                          overflow: TextOverflow.ellipsis, // prevents overflow
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "${job.growth} growth",
                          overflow: TextOverflow.ellipsis, // prevents overflow
                          textAlign: TextAlign.end,
                          style: TextStyle(color: getGrowthColor(job.growth), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )
,
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("📍 ${job.hotspots.isNotEmpty ? job.hotspots.first : 'N/A'}"),
                      TextButton(
                        onPressed: () => setState(() => expandedJobId = isExpanded ? null : job.title),
                        child: Text(isExpanded ? "Less Details" : "More Details"),
                      ),
                    ],
                  ),

                  if (isExpanded) ...[
                    const Divider(),
                    const SizedBox(height: 8),
                    Text("Requirements:", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 6,
                      children: job.requirements.map((r) => Chip(label: Text(r))).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text("Education: ${job.education}"),
                    const SizedBox(height: 8),
                    Text("Top Employers: ${job.companies.join(', ')}"),
                    Text("Key Locations: ${job.hotspots.join(', ')}"),
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
        }),

        if (filteredJobs.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: const [
                  Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("No jobs found", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Try selecting another category", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Career Tips
        Card(
          color: Colors.green[50],
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Career Growth Tips", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("• Technology and healthcare are among the fastest-growing sectors."),
                Text("• Skills like Data Analysis, Programming, and Project Management are highly valued."),
                Text("• Continuous learning and certifications boost earning potential."),
                Text("• Remote and hybrid work opportunities are increasing."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
