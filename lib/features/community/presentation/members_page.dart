
import 'package:catalansalmon_flutter/features/community/model/community_member.dart';
import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key, required this.members});

  final List<CommunityMember> members;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Comunitats')),
        body: SafeArea(
          child: Stack(children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: 80),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                  //leading: ColorDot(color: com.color),
                  title: Text(member.name),
                  onTap: () {
                  },
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  hintText: 'Cerca membres',
                  hintStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(color: Color.fromARGB(120, 0, 0, 0))),
                  leading: const SizedBox(width: 8),
                  trailing: const [Icon(Icons.search), SizedBox(width: 16)],
                  onChanged: (value) {
                    
                  } ,
                );
              }, suggestionsBuilder: ((context, controller) => {})),
            ),
          ],),
        )
      );
  }
}