
import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/community-search/cubit/csearch_cubit.dart';
import 'package:catalansalmon_flutter/features/community-search/cubit/csearch_state.dart';
import 'package:catalansalmon_flutter/features/community/presentation/community_page.dart';
import 'package:catalansalmon_flutter/widgets/color_dot.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunitySearchPage extends StatefulWidget {
  const CommunitySearchPage({super.key});

  @override
  State<CommunitySearchPage> createState() => _CommunitySearchPageState();
}

class _CommunitySearchPageState extends State<CommunitySearchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = CommunityRepository();
        final cubit = CommunitySearchCubit(repo);
        cubit.fetchAllCommunities();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Comunitats')),
        body: SafeArea(
          child: Stack(children: [
            BlocBuilder<CommunitySearchCubit, CommunitySearchState>(builder: (context, state) {
              if (state is ResponseCommunitySearchState) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 80),
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    final com = state.results[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      leading: ColorDot(color: com.color),
                      title: Text(com.nom),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${com.numUsuaris}', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 8),
                          const Icon(Icons.people_alt_outlined, color: Colors.grey)
                        ]
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityPage(community: com)));
                      },
                    );
                  }
                );
              }
              if (state is ErrorCommunitySearchState) {
                return Center(child: Text(state.message));
              }
              return const Center(child: GlobeLogo());
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  hintText: 'Troba la teva comunitat!',
                  hintStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(color: Color.fromARGB(120, 0, 0, 0))),
                  leading: const SizedBox(width: 8),
                  trailing: const [Icon(Icons.search), SizedBox(width: 16)],
                  onChanged: (value) {
                    context.read<CommunitySearchCubit>().search(value);
                  } ,
                );
              }, suggestionsBuilder: ((context, controller) => {})),
            ),
          ],),
        )
      ),
    );
  }
}