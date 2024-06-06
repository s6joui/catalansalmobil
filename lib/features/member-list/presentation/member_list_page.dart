import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/community/presentation/member_avatar.dart';
import 'package:catalansalmon_flutter/features/member-list/cubit/member_list_cubit.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage(
      {super.key,
      required this.communityId,
      required this.communityColor,
      required this.foregroundColor});

  final String communityId;
  final Color communityColor;
  final Color foregroundColor;

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = CommunityRepository();
        final cubit = MemberListCubit(repo);
        cubit.fetchCommunityMembers(widget.communityId);
        return cubit;
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Membres')),
          body: SafeArea(
            child: BlocBuilder<MemberListCubit, MemberListState>(
                builder: (context, state) {
              if (state is ResponseMemberListState) {
                return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: state.results.length,
                    itemBuilder: (context, i) {
                      final member = state.results[i];
                      return ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                        leading: MemberAvatar(
                            color: widget.communityColor,
                            name: member.name,
                            foregroundColor: widget.foregroundColor),
                        title: Text(member.name),
                      );
                    }).animate().fadeIn();
              }
              if (state is ErrorMemberListState) {
                return Center(child: Text(state.message));
              }
              return const Center(child: GlobeLogo());
            }),
          )),
    );
  }
}
