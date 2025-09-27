import 'package:flutter/material.dart';
import 'package:learn_bridge_v2/features/data/user_response.dart';
import '../../data/profile/user_profile.dart' as profile_data;
import '../../data/course/course.dart' as course_data;
import '../course_details/course_detail_page.dart';
import '../job_market/job_market_page.dart';
import '../profile_page/profile_page.dart';
import '../../service/service.dart';

class DashboardScreen extends StatelessWidget {
  final UserResponse? userProfile;
  final void Function(String) onNavigate;

  DashboardScreen({
    super.key,
    required this.userProfile,
    required this.onNavigate,
    required Null Function(dynamic course) onCourseSelect,
  });


  final List<course_data.Course> sampleCourses = [
    course_data.Course(
      id: '1',
      name: 'Computer Science',
      description: 'Learn programming, algorithms, and software development',
      requiredSubjects: ['Mathematics', 'Physical Sciences'],
      university: 'University of the Witwatersrand',
      duration: '4 years',
      qualification: 'Bachelor of Science',
    ),
    course_data.Course(
      id: '2',
      name: 'Mechanical Engineering',
      description: 'Design and build mechanical systems',
      requiredSubjects: [
        'Mathematics',
        'Physical Sciences',
        'Engineering Graphics and Design',
      ],
      university: 'University of Cape Town',
      duration: '4 years',
      qualification: 'Bachelor of Engineering',
    ),
    course_data.Course(
      id: '3',
      name: 'Business Administration',
      description: 'Learn business management and entrepreneurship',
      requiredSubjects: ['Mathematics', 'Business Studies', 'Accounting'],
      university: 'Stellenbosch University',
      duration: '3 years',
      qualification: 'Bachelor of Commerce',
    ),
  ];

  final List<Map<String, String>> jobTrends = [
    {
      'title': 'Software Developer',
      'demand': 'High',
      'salary': 'R35,000 - R85,000',
    },
    {
      'title': 'Data Scientist',
      'demand': 'Very High',
      'salary': 'R40,000 - R100,000',
    },
    {
      'title': 'Digital Marketing Specialist',
      'demand': 'High',
      'salary': 'R25,000 - R55,000',
    },
  ];

  final List<Map<String, String>> fundingOpportunities = [
    {'name': 'NSFAS Bursary', 'type': 'Government', 'amount': 'Full Coverage'},
    {'name': 'Sasol Bursary', 'type': 'Corporate', 'amount': 'R80,000/year'},
    {
      'name': 'Allan Gray Orbis Foundation',
      'type': 'Private',
      'amount': 'Full Coverage',
    },
  ];

  Color getDemandColor(String demand) {
    switch (demand) {
      case 'Very High':
        return Colors.green.shade100;
      case 'High':
        return Colors.blue.shade100;
      case 'Medium':
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${userProfile?.name}!',
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
                      userProfile!.subjects.length,
                      Icons.book,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Interests',
                      userProfile!.interests.length,
                      Icons.star,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'Matches',
                      12,
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
                    children: sampleCourses.map((course) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left side: course info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        if (course.requiredSubjects.length > 2)
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

                              // Right side: arrow navigates to course detail
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CourseDetailsPage(course: course),
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
                    children: jobTrends.map((job) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    job['salary']!,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getDemandColor(
                                    job['demand']!,
                                  ).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  job['demand']!,
                                  style: const TextStyle(fontSize: 12),
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
                    children: fundingOpportunities.map((fund) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fund['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      fund['type']!,
                                      style: TextStyle(color: Colors.grey[700]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                fund['amount']!,
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
                const SizedBox(height: 20),

                // AI Recommendations Button
                ElevatedButton(
                  onPressed: () => onNavigate('recommendations'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star),
                      SizedBox(width: 8),
                      Text('View AI Recommendations'),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              onNavigate('courses');
              break;
            case 1:
              onNavigate('funding');
              break;
            case 2:
            // ✅ Navigate to JobMarketPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobMarketPage(
                    userProfile: userProfile,
                    onBack: () {
                      Navigator.pop(context); // Go back to dashboard
                    },
                  ),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userProfile: userProfile,
                    onNavigate: (String p1) {},
                  ),
                ),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.blue),
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

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 12, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
