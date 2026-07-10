import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunityDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const OpportunityDetailsPage({
    super.key,
    required this.data,
  });

  Future<void> openLink(
      BuildContext context,
      String link,
      ) async {
    try {
      final Uri url = Uri.parse(link);

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not open link: $e",
          ),
        ),
      );
    }

  }

  Widget buildDetail(
      String label,
      dynamic value,
      ) {
    if (value == null ||
        value.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        "$label: $value",
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

  }
  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required dynamic value,
  }) {
    if (value == null || value.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final String link =
    data['registrationLink']?.toString().isNotEmpty == true
        ? data['registrationLink']
        : data['link']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF9EB294),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          data['title'] ??
              data['teamName'] ??
              data['name'] ??
              "Details",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.deepPurple,
                    Colors.purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ??
                        data['teamName'] ??
                        data['name'] ??
                        "Details",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data['company'] ??
                        data['organizer'] ??
                        "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildInfoCard(
              icon: Icons.business,
              title: "Company",
              value: data['company'],
            ),

            buildInfoCard(
              icon: Icons.groups,
              title: "Organizer",
              value: data['organizer'],
            ),

            buildInfoCard(
              icon: Icons.language,
              title: "Platform",
              value: data['platform'],
            ),

            buildInfoCard(
              icon: Icons.category,
              title: "Category",
              value: data['category'],
            ),

            buildInfoCard(
              icon: Icons.work,
              title: "Type",
              value: data['type'],
            ),

            buildInfoCard(
              icon: Icons.calendar_today,
              title: "Date",
              value: data['date'],
            ),

            buildInfoCard(
              icon: Icons.location_on,
              title: "Venue",
              value: data['venue'],
            ),

            buildInfoCard(
              icon: Icons.mic,
              title: "Speaker",
              value: data['speaker'],
            ),

            buildInfoCard(
              icon: Icons.workspace_premium,
              title: "Certificate",
              value: data['certificate'],
            ),

            buildInfoCard(
              icon: Icons.currency_rupee,
              title: "Event Fee",
              value: data['eventFee'],
            ),

            buildInfoCard(
              icon: Icons.school,
              title: "Course Level",
              value: data['level'],
            ),

            buildInfoCard(
              icon: Icons.computer,
              title: "Domain",
              value: data['domain'],
            ),

            buildInfoCard(
              icon: Icons.place,
              title: "Location",
              value: data['location'],
            ),

            buildInfoCard(
              icon: Icons.wifi,
              title: "Mode",
              value: data['mode'],
            ),

            buildInfoCard(
              icon: Icons.schedule,
              title: "Duration",
              value: data['duration'],
            ),

            buildInfoCard(
              icon: Icons.payments,
              title: "Stipend",
              value: data['stipend'],
            ),

            buildInfoCard(
              icon: Icons.verified_user,
              title: "Eligibility",
              value: data['eligibility'],
            ),

            buildInfoCard(
              icon: Icons.code,
              title: "Skills Required",
              value: data['skillsRequired'],
            ),

            buildInfoCard(
              icon: Icons.group,
              title: "Team Size",
              value: data['teamSize'],
            ),

            buildInfoCard(
              icon: Icons.attach_money,
              title: "Registration Fee",
              value: data['registrationFee'],
            ),

            buildInfoCard(
              icon: Icons.emoji_events,
              title: "Prize",
              value: data['prize'],
            ),

            buildInfoCard(
              icon: Icons.event_available,
              title: "Deadline",
              value: data['deadline'],
            ),

            buildInfoCard(
              icon: Icons.star,
              title: "Required Skill",
              value: data['requiredSkill'],
            ),

            buildInfoCard(
              icon: Icons.person_outline,
              title: "Preferred Role",
              value: data['preferredRole'],
            ),

            buildInfoCard(
              icon: Icons.people,
              title: "Members Needed",
              value: data['membersNeeded'],
            ),

            buildInfoCard(
              icon: Icons.phone,
              title: "Contact",
              value: data['contact'],
            ),

            buildInfoCard(
              icon: Icons.group_add,
              title: "Looking For Team",
              value: data['lookingForTeam'],
            ),

            buildInfoCard(
              icon: Icons.assignment,
              title: "Available For Projects",
              value: data['availableForProjects'],
            ),

            buildInfoCard(
              icon: Icons.rocket_launch,
              title: "Available For Hackathons",
              value: data['availableForHackathons'],
            ),

            buildInfoCard(
              icon: Icons.info,
              title: "About Me",
              value: data['aboutMe'],
            ),

            buildInfoCard(
              icon: Icons.account_tree,
              title: "Branch",
              value: data['branch'],
            ),

            buildInfoCard(
              icon: Icons.flag,
              title: "Career Goal",
              value: data['careerGoal'],
            ),

            buildInfoCard(
              icon: Icons.location_city,
              title: "City",
              value: data['city'],
            ),

            buildInfoCard(
              icon: Icons.school_outlined,
              title: "College",
              value: data['college'],
            ),

            buildInfoCard(
              icon: Icons.psychology,
              title: "Skills",
              value: data['skills'],
            ),

            buildInfoCard(
              icon: Icons.class_,
              title: "Year",
              value: data['year'],
            ),

            buildInfoCard(
              icon: Icons.code,
              title: "GitHub",
              value: data['githubLink'],
            ),

            buildInfoCard(
              icon: Icons.business_center,
              title: "LinkedIn",
              value: data['linkedInLink'],
            ),

            const SizedBox(height: 15),

            if ((data['description'] ?? '').toString().isNotEmpty)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        data['description'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            if (link.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      openLink(context, link);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text("Apply Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

  }
}