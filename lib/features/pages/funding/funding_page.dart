import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/funding_response.dart';
import '../../service/service.dart';

class FundingPage extends StatefulWidget {
  final VoidCallback onBack;

  const FundingPage({super.key, required this.onBack});

  @override
  State<FundingPage> createState() => _FundingPageState();
}

class _FundingPageState extends State<FundingPage> {
  String selectedType = 'All';
  String? expandedCard;

  List<Funding> fundingList = [];
  bool isLoading = true;

  final List<String> fundingTypes = [
    'All',
    'Government',
    'Corporate',
    'Private',
  ];

  @override
  void initState() {
    super.initState();
    fetchFundingData();
  }

  Future<void> fetchFundingData() async {
    try {
      final response = await Service().getFundingData();
      if (response != null) {
        setState(() {
          fundingList = response.fundingList;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching funding data: $e");
    }
  }

  List<Funding> get filteredFunding {
    return fundingList.where((fund) {
      return selectedType == 'All' || fund.type == selectedType;
    }).toList();
  }

  Color typeColor(String type) {
    switch (type) {
      case 'Government':
        return Colors.blue.shade100;
      case 'Corporate':
        return Colors.green.shade100;
      case 'Private':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            buildAppBar(),

            // Body
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Filter Chips
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: fundingTypes.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final type = fundingTypes[index];
                                final isSelected = selectedType == type;
                                return ChoiceChip(
                                  label: Text(type),
                                  selected: isSelected,
                                  onSelected: (_) =>
                                      setState(() => selectedType = type),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Quick Stats / AI Insight
                          Card(
                            color: Colors.orange.shade50,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.yellow.shade100,
                                child: const Icon(
                                  Icons.insights,
                                  color: Colors.orange,
                                ),
                              ),
                              title: const Text(
                                "AI Insight",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text(
                                "Most bursaries close between July–November. Apply early!",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Funding List
                          ...filteredFunding.map((fund) {
                            final isExpanded = expandedCard == fund.id;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Top Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: typeColor(fund.type),
                                          child: const Icon(
                                            Icons.school,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
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
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: typeColor(
                                                          fund.type,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        fund.type,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black87,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      fund.amount,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      fund.description,
                                      maxLines: isExpanded ? null : 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Deadline: ${fund.deadline}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () => setState(() {
                                            expandedCard = isExpanded
                                                ? null
                                                : fund.id;
                                          }),
                                          child: Text(
                                            isExpanded ? "Less" : "More",
                                            style: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (isExpanded) ...[
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Fields of Study:",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 6,
                                        children: fund.fields
                                            .map(
                                              (f) => Chip(
                                                label: Text(
                                                  f,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Coverage:",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: fund.coverage
                                            .map(
                                              (c) => Text(
                                                "• $c",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Requirements:",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: fund.requirements
                                            .map(
                                              (r) => Text(
                                                "• $r",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 8),
                                      if (fund.website.isNotEmpty)
                                        TextButton(
                                          onPressed: () => launchUrl(
                                            Uri.parse(fund.website),
                                          ),
                                          child: const Text("Visit Website"),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }).toList(),

                          if (filteredFunding.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: const [
                                  Icon(
                                    Icons.money_off,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "No funding recommendations right now",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Check back later for more opportunities",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          // Application Tips
                          Card(
                            color: Colors.blue.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: const Icon(
                                      Icons.tips_and_updates,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Application Tips",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "• Apply early – deadlines fill up fast",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "• Prepare documents in advance",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "• Write a strong motivation letter",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "• Apply to multiple bursaries",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

// --- Funding Page App Bar with Dollar Icon ---
  PreferredSizeWidget buildAppBar() {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Dollar Icon Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Text Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Recommended Funding",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changed to white for contrast
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Opportunities matched to you",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white, // Slightly transparent
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
