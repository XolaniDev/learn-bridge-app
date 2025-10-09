import 'package:flutter/material.dart';
import '../../data/dashboardResponse.dart';
import '../../data/course/course.dart';
import '../../service/service.dart';
import '../course_details/course_detail_page.dart';
import '../funding/funding_page.dart';
import '../job_market/job_market_page.dart';
import '../profile_page/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  final dynamic userProfile;
  final void Function(String) onNavigate;

  const DashboardScreen({
    super.key,
    required this.userProfile,
    required this.onNavigate,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardResponse?> _dashboardData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _dashboardData = Service().getDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DashboardResponse?>(
          future: _dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No dashboard data available"));
            }

            final dashboard = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${widget.userProfile?.name ?? 'Learner'}!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Ready to explore your career path?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        'Subjects',
                        dashboard.subjects,
                        Icons.book,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Interests',
                        dashboard.interests,
                        Icons.star,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Matches',
                        dashboard.matches,
                        Icons.trending_up,
                        Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Recommended Courses
                  _buildSectionCard(
                    title: 'Recommended Courses',
                    subtitle: 'AI Matched',
                    child: Column(
                      children: dashboard.recommendedCourses.map((course) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        course.university,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Wrap(
                                        spacing: 4,
                                        runSpacing: 2,
                                        children: [
                                          ...course.requiredSubjects
                                              .take(2)
                                              .map(
                                                (s) => Chip(
                                                  label: Text(
                                                    s,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          if (course.requiredSubjects.length >
                                              2)
                                            Chip(
                                              label: Text(
                                                '+${course.requiredSubjects.length - 2} more',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Map RecommendedCourse → Course
                                    final mappedCourse = Course(
                                      id: course.id,
                                      name: course.name,
                                      description: course.description,
                                      requiredSubjects: List<String>.from(
                                        course.requiredSubjects,
                                      ),
                                      university: course.university,
                                      duration: course.duration,
                                      qualification: course.qualification,
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CourseDetailsPage(
                                          course: mappedCourse,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Job Trends
                  _buildSectionCard(
                    title: 'Hot Job Markets',
                    child: Column(
                      children: dashboard.jobTrends.map((job) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side: Job title and salary
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        // prevent text from overflowing
                                        maxLines: 1, // limit title to one line
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        job.salary,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Right side: Demand badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getDemandColor(
                                      job.demand,
                                    ).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    job.demand,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Funding Opportunities
                  _buildSectionCard(
                    title: 'Funding Available',
                    child: Column(
                      children: dashboard.fundingOpportunities.map((fund) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fund.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        fund.type,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  fund.amount,
                                  style: TextStyle(
                                    color: Colors.green[500],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0: // Courses (Dashboard)
              widget.onNavigate('courses');
              break;
            case 1: // Funding
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FundingPage(onBack: () {}),
                ),
              );
              break;
            case 2: // Jobs
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobMarketPage(
                    userProfile: widget.userProfile,
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
              break;
            case 3: // Profile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userProfile: widget.userProfile,
                    onNavigate: (screen) {},
                  ),
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.grey),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money, color: Colors.grey),
            label: 'Funding',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Colors.grey),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Color getDemandColor(String demand) {
    switch (demand.toLowerCase()) {
      case "very high":
        return Colors.red;
      case "high":
        return Colors.orange;
      case "medium":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
