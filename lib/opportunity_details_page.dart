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

  @override
  Widget build(BuildContext context) {

    final String link =
    data['registrationLink']?.toString().isNotEmpty == true
        ? data['registrationLink']
        : data['link']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
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

            Text(
              data['title'] ??
                  data['teamName'] ??
                  data['name'] ??
                  'Details',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            buildDetail(
              "Company",
              data['company'],
            ),

            buildDetail(
              "Organizer",
              data['organizer'],
            ),
            buildDetail(
              "Platform",
              data['platform'],
            ),

            buildDetail(
              "Category",
              data['category'],
            ),

            buildDetail(
              "Type",
              data['type'],
            ),

            buildDetail(
              "Date",
              data['date'],
            ),

            buildDetail(
              "Venue",
              data['venue'],
            ),

            buildDetail(
              "Speaker",
              data['speaker'],
            ),

            buildDetail(
              "Certificate",
              data['certificate'],
            ),

            buildDetail(
              "Event Fee",
              data['eventFee'],
            ),

            buildDetail(
              "Course Level",
              data['level'],
            ),


            buildDetail(
              "Domain",
              data['domain'],
            ),

            buildDetail(
              "Location",
              data['location'],
            ),

            buildDetail(
              "Mode",
              data['mode'],
            ),

            buildDetail(
              "Duration",
              data['duration'],
            ),

            buildDetail(
              "Stipend",
              data['stipend'],
            ),

            buildDetail(
              "Eligibility",
              data['eligibility'],
            ),

            buildDetail(
              "Skills Required",
              data['skillsRequired'],
            ),

            buildDetail(
              "Team Size",
              data['teamSize'],
            ),

            buildDetail(
              "Registration Fee",
              data['registrationFee'],
            ),

            buildDetail(
              "Prize",
              data['prize'],
            ),

            buildDetail(
              "Deadline",
              data['deadline'],
            ),

            buildDetail(
              "Required Skill",
              data['requiredSkill'],
            ),

            buildDetail(
              "Preferred Role",
              data['preferredRole'],
            ),

            buildDetail(
              "Members Needed",
              data['membersNeeded'],
            ),

            buildDetail(
              "Contact",
              data['contact'],
            ),

            buildDetail(
              "Looking For Team",
              data['lookingForTeam'],
            ),

            buildDetail(
              "Available For Projects",
              data['availableForProjects'],
            ),

            buildDetail(
              "Available For Hackathons",
              data['availableForHackathons'],
            ),

            buildDetail(
              "About Me",
              data['aboutMe'],
            ),

            buildDetail(
              "Branch",
              data['branch'],
            ),

            buildDetail(
              "Career Goal",
              data['careerGoal'],
            ),

            buildDetail(
              "City",
              data['city'],
            ),

            buildDetail(
              "College",
              data['college'],
            ),

            buildDetail(
              "Skills",
              data['skills'],
            ),

            buildDetail(
              "Year",
              data['year'],
            ),

            buildDetail(
              "GitHub",
              data['githubLink'],
            ),

            buildDetail(
              "LinkedIn",
              data['linkedInLink'],
            ),

            const SizedBox(height: 15),

            if ((data['description'] ?? '')
                .toString()
                .isNotEmpty)
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    data['description'],
                    style:
                    const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 30),

            if (link.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    openLink(
                      context,
                      link,
                    );
                  },
                  child: const Text(
                    "Open Link",
                  ),
                ),
              ),
          ],
        ),
      ),
    );

  }
}