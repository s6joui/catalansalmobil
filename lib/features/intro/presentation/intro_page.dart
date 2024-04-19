import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/community-search/presentation/community_search_page.dart';
import 'package:catalansalmon_flutter/features/community/presentation/community_page.dart';
import 'package:catalansalmon_flutter/features/intro/cubit/intro_cubit.dart';
import 'package:catalansalmon_flutter/features/intro/cubit/intro_state.dart';
import 'package:catalansalmon_flutter/features/intro/presentation/community_button.dart';
import 'package:catalansalmon_flutter/model/community.dart';
import 'package:catalansalmon_flutter/widgets/cam_logo.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authRepo = context.read<AuthRepository>();
        final repo = CommunityRepository();
        final cubit = IntroCubit(authRepo, repo);
        cubit.startIntroFlow();
        return cubit;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<IntroCubit, IntroState>(
            listener: (context, state) {
              if (state is ErrorIntroState) {
                showModalBottomSheet(context: context, builder: (innerContext) {
                  return SizedBox(width: double.infinity, height: 130, child: Text(state.message));
                });
              }
              if (state is LoginSuccessIntroState) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CommunityPage.fromDetails(state.details))
                ).then((_) {
                  // When coming back
                  context.read<IntroCubit>().fetchNearbyCommunities();
                });
              }
            },
            builder: (context, state) {
              if (state is ResponseIntroState) {
                return CommunitySelectionWidget(communities: state.nearbyCommunities);
              }
              return const Center(child: GlobeLogo());
          })
        ),
      ),
    );
  }
}

class CommunitySelectionWidget extends StatelessWidget {
  final List<Community> communities;

  const CommunitySelectionWidget({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ((MediaQuery.of(context).size.height - 600) / 2)),
            //Text('', style: Theme.of(context).textTheme.headlineSmall?.apply(fontWeightDelta: -2)),
            const CAMLogo(),
            const SizedBox(height: 4),
            Text('Uneix-te a una de les comunitats a prop teu!', style: Theme.of(context).textTheme.bodyMedium?.apply(fontWeightDelta: -1)),
            const SizedBox(height: 24),
            ...communities.map((com) {
              return CommunityButton(title: com.nom, color: com.color, onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityPage(community: com)));
              },);
            }),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CommunitySearchPage()));
            }, child: const Text('Veure totes les comunitats')),
            const Spacer(),
          ].animate(interval: 400.ms).fade(duration: 500.ms, curve: Curves.easeOut).slideY(begin: 2, end: 0, duration: 300.ms),
      ),
    );
  }
}