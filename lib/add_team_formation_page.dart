import 'package:flutter/material.dart';

class AddTeamFormationPage extends StatefulWidget {
  const AddTeamFormationPage({super.key});

  @override
  State<AddTeamFormationPage> createState() => _AddTeamFormationPageState();
}

class _AddTeamFormationPageState extends State<AddTeamFormationPage> {

  final nameController = TextEditingController();
  final skillController = TextEditingController();
  final requirementController = TextEditingController();

  final List<Map<String, String>> teams = [];

  void addTeam() {

    if (nameController.text.isNotEmpty &&
        skillController.text.isNotEmpty &&
        requirementController.text.isNotEmpty) {

      setState(() {

        teams.add({
          "name": nameController.text,
          "skill": skillController.text,
          "requirement": requirementController.text,
        });

      });

      nameController.clear();
      skillController.clear();
      requirementController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Team request added successfully"),
        ),
      );

    }

  }


  void deleteTeam(int index){

    setState(() {
      teams.removeAt(index);
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Team Formation"),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [


            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 12),


            TextField(
              controller: skillController,
              decoration: const InputDecoration(
                labelText: "Your Skills",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 12),


            TextField(
              controller: requirementController,
              decoration: const InputDecoration(
                labelText: "Team Requirement",
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 15),


            ElevatedButton(

              onPressed: addTeam,

              child: const Text(
                "Create Team Request",
              ),

            ),


            const SizedBox(height: 20),


            Expanded(

              child: ListView.builder(

                itemCount: teams.length,


                itemBuilder: (context,index){


                  return Card(

                    child: ListTile(

                      title: Text(
                        teams[index]["name"]!,
                      ),


                      subtitle: Text(

                        "Skills: ${teams[index]["skill"]}\n"
                            "Need: ${teams[index]["requirement"]}",

                      ),


                      trailing: IconButton(

                        icon: const Icon(Icons.delete),

                        onPressed: (){

                          deleteTeam(index);

                        },

                      ),

                    ),

                  );


                },

              ),

            )


          ],

        ),

      ),

    );

  }

}