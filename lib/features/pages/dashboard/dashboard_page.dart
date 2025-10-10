import 'package:flutter/material.dart';
import '../../data/dashboardResponse.dart';
import '../../data/course/course.dart';
import '../../service/service.dart';
import '../course_details/course_detail_page.dart';
import '../funding/funding_page.dart';
import '../job_market/job_market_page.dart';
import '../profile_page/profile_page.dart';
import 'package:lottie/lottie.dart';

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

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _dashboardData = Service().getDashboardData();

    _pages = [
      _buildDashboardTab(), // Courses / Dashboard
      FundingPage(onBack: () {}), // Funding
      JobMarketPage(userProfile: widget.userProfile, onBack: () {}), // Jobs
      ProfilePage(
        userProfile: widget.userProfile,
        onNavigate: (screen) {},
      ), // Profile
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _pages[_selectedIndex], // Display selected page
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index); // switch tabs
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Funding',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // --- Dashboard Tab (Courses) ---
  Widget _buildDashboardTab() {
    return FutureBuilder<DashboardResponse?>(
      future: _dashboardData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    'assets/loading.json', // 🌀 Your Lottie file
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "AI is busy generating your recommendations...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This may take a few seconds ⏳",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );

        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No dashboard data available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }


        final dashboard = snapshot.data!;

        return Column(
          children: [
            // Static Header
            buildDashboardAppBar(),
            const SizedBox(height: 20),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                    const SizedBox(height: 8),

                    // Recommended Courses - Premium UI
                    _buildSectionCard(
                      title: 'Recommended Courses',
                      subtitleWidget: Lottie.asset(
                        'assets/ai_animation.json',
                        // Your Lottie JSON file path
                        width: 80, // Adjust size as needed
                        height: 80,
                        fit: BoxFit.contain,
                        repeat: true, // Loop animation
                      ),
                      child: Column(
                        children: dashboard.recommendedCourses.map((course) {
                          return GestureDetector(
                            onTap: () {
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
                                  builder: (context) =>
                                      CourseDetailsPage(course: mappedCourse),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.white70],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Course Info
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
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: [
                                              ...course.requiredSubjects
                                                  .take(2)
                                                  .map(
                                                    (s) =>
                                                    Chip(
                                                      backgroundColor:
                                                      Colors.blue.shade50,
                                                      label: Text(
                                                        s,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                          Colors.blueAccent,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                              if (course
                                                  .requiredSubjects
                                                  .length >
                                                  2)
                                                Chip(
                                                  backgroundColor:
                                                  Colors.blue.shade100,
                                                  label: Text(
                                                    '+${course.requiredSubjects
                                                        .length - 2} more',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Arrow Icon with circular background
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueAccent.withOpacity(
                                          0.2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Job Trends
                    _buildSectionCard(
                      title: 'Hot Job Market',
                      subtitleWidget: Lottie.asset(
                        'assets/ai_animation.json',
                        // Your Lottie JSON file path
                        width: 80, // Adjust size as needed
                        height: 100,
                        fit: BoxFit.contain,
                        repeat: true, // Loop animation
                      ),
                      child: Column(
                        children: dashboard.jobTrends.map((job) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade100],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 📌 Job Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            job.salary,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // 📊 Demand Badge with Icon
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getDemandColor(
                                          job.demand,
                                        ).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: getDemandColor(job.demand),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.trending_up,
                                            color: getDemandColor(job.demand),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            job.demand,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: getDemandColor(job.demand),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    _buildSectionCard(
                      title: 'Funding Available',
                      subtitleWidget: Lottie.asset(
                        'assets/ai_animation.json',
                        // Your Lottie JSON file path
                        width: 80, // Adjust size as needed
                        height: 80,
                        fit: BoxFit.contain,
                        repeat: true, // Loop animation
                      ),
                      child: Column(
                        children: dashboard.fundingOpportunities.map((fund) {
                          return GestureDetector(
                            onTap: () {
                              // You can navigate to a funding detail page here if needed
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade100],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // 🏦 Funding Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fund.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            fund.type,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // 💰 Funding Amount Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.monetization_on_outlined,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            fund.amount,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    required Widget child,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟦 Title + Lottie in the same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitleWidget != null)
                  subtitleWidget
                else
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with circular gradient background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.7), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

  PreferredSizeWidget buildDashboardAppBar() {
    final userName = widget.userProfile?.name ?? 'Learner';
    final learnerNumber = widget.userProfile?.learnerNumber ?? 'N/A';

    return PreferredSize(
      preferredSize: const Size.fromHeight(140),
      child: Container(
        height: 130,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),

                // Wrap row in Flexible to prevent overflow
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade900,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty ? userName[0] : 'L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome back, $userName!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Learner Number: $learnerNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // const Text(
                            //   'Ready to explore your career path?',
                            //   style: TextStyle(
                            //     color: Colors.white70,
                            //     fontSize: 14,
                            //   ),
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
