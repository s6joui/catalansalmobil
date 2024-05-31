import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/auth/presentation/login_page.dart';
import 'package:catalansalmon_flutter/features/community/cubit/community_cubit.dart';
import 'package:catalansalmon_flutter/features/community/cubit/community_state.dart';
import 'package:catalansalmon_flutter/features/community/model/community_details.dart';
import 'package:catalansalmon_flutter/features/community/model/community_member.dart';
import 'package:catalansalmon_flutter/features/community/model/community_post.dart';
import 'package:catalansalmon_flutter/features/community/presentation/create_post_widget.dart';
import 'package:catalansalmon_flutter/features/community/presentation/member_avatar.dart';
import 'package:catalansalmon_flutter/features/intro/presentation/intro_page.dart';
import 'package:catalansalmon_flutter/features/member-list/presentation/member_list_page.dart';
import 'package:catalansalmon_flutter/features/post/presentation/post_detail_page.dart';
import 'package:catalansalmon_flutter/secrets.dart';
import 'package:catalansalmon_flutter/model/community.dart';
import 'package:catalansalmon_flutter/utils/widget_extensions.dart';
import 'package:catalansalmon_flutter/widgets/color_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required this.community, this.details});

  factory CommunityPage.fromDetails(CommunityDetails details) {
    return CommunityPage(
        community: Community.fromCommunityDetails(details), details: details);
  }

  final Community community;
  final CommunityDetails? details;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    textColor = widget.community.color.computeLuminance() >= 0.67
        ? Colors.black
        : Colors.white;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
        CachedNetworkImageProvider(widget.community.mapUrl()), context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = CommunityRepository();
        final authRepo = context.read<AuthRepository>();
        final cubit = CommunityCubit(widget.community, repo, authRepo);
        cubit.fetchContent(widget.details);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(mainAxisSize: MainAxisSize.min, children: [
            ColorDot(color: widget.community.color),
            const SizedBox(width: 8),
            Text(widget.community.nom)
          ]),
          leading: IconButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          const IntroPage(shouldAttemptLogin: false)));
                }
              },
              icon: Icon(Icons.adaptive.arrow_back_rounded)),
          actions: [
            BlocBuilder<CommunityCubit, CommunityState>(
                builder: (context, state) {
              if (state is! ResponseCommunityState) {
                return const SizedBox();
              }
              if (!state.isLoggedIn) {
                return const SizedBox();
              }
              return PopupMenuButton(itemBuilder: (context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                    onTap: () => context.read<CommunityCubit>().logout(),
                  );
                }).toList();
              });
            })
          ],
        ),
        body: BlocBuilder<CommunityCubit, CommunityState>(
          builder: (context, state) {
            if (state is ErrorCommunityState) {
              return Text(state.message);
            }
            return Stack(
              children: [
                state is ResponseCommunityState
                    ? _CommunityBody(
                        community: widget.community,
                        details: state.details,
                        posts: state.posts,
                        members: state.details.membres,
                        textColor: textColor,
                        isLoggedIn: state.isLoggedIn)
                    : const SizedBox(),
                AnimatedOpacity(
                  opacity: state is ResponseCommunityState ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: _CommunityPageSkeleton(community: widget.community),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CommunityBody extends StatelessWidget {
  const _CommunityBody(
      {required this.community,
      required this.details,
      required this.posts,
      required this.members,
      required this.isLoggedIn,
      required this.textColor});

  final Community community;
  final CommunityDetails details;
  final List<CommunityPost> posts;
  final List<CommunityMember> members;
  final bool isLoggedIn;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommunityMembersSection(
                  members: members,
                  memberCount: details.numUsuaris,
                  color: details.color,
                  textColor: textColor,
                  communityId: details.id),
              CommunityPostsSection(posts: posts, community: community),
              _CommunityInfoSection(details: details),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 88),
            ],
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              if (isLoggedIn)
                SizedBox(
                    height: 54,
                    child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: community.color,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (innerContext) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(innerContext)
                                              .viewInsets
                                              .bottom),
                                      child: CreatePostWidget(
                                        communityId: community.id,
                                        postResultHandler: () {
                                          context
                                              .read<CommunityCubit>()
                                              .fetchContent(null,
                                                  bypassCache: true);
                                        },
                                      ),
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Crea un post',
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      letterSpacing: -0.5,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.create),
                              ],
                            ))
                        .animate()
                        .fadeIn()
                        .scale(
                            curve: const ElasticOutCurve(0.7),
                            duration: 600.ms))
              else
                SizedBox(
                    height: 54,
                    child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: community.color,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (innerContext) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(innerContext)
                                              .viewInsets
                                              .bottom),
                                      child: LoginPage(
                                          communityId: community.id,
                                          loginResultHandler: (success) {
                                            context
                                                .read<CommunityCubit>()
                                                .checkAuthChange();
                                          }),
                                    );
                                  });
                            },
                            child: Text(
                              'Uneix-te a la comunitat!',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ))
                        .animate()
                        .fadeIn()
                        .scale(
                            curve: const ElasticOutCurve(0.7), duration: 600.ms)
                        .then()
                        .animate(onPlay: (controller) => controller.repeat())
                        .shimmer(delay: 6.seconds, duration: 500.ms)
                        .scaleXY(begin: 1.0, end: 1.1, curve: Curves.easeIn)
                        .then()
                        .scaleXY(begin: 1.1, end: 1.0, curve: Curves.easeOut)),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        )
      ],
    );
  }
}

extension CommunityExtension on Community {
  String mapUrl() {
    return "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/$lng,$lat,10/400x200?access_token=$mapBoxApiKey";
  }
}

extension CommunityDetailsExtension on CommunityDetails {
  String mapUrl() {
    return "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/$lng,$lat,10/400x200?access_token=$mapBoxApiKey";
  }
}

class CommunityPostsSection extends StatelessWidget {
  const CommunityPostsSection(
      {super.key, required this.posts, required this.community});

  final List<CommunityPost> posts;
  final Community community;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _SectionTitle(text: 'Tauler'),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                child: _CommunityPostWidget(post: post, community: community),
              );
            },
          ),
        )
      ],
    );
  }
}

class _CommunityPostWidget extends StatelessWidget {
  const _CommunityPostWidget({required this.post, required this.community});

  final CommunityPost post;
  final Community community;

  @override
  Widget build(BuildContext context) {
    return Ink(
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, 5),
                  blurRadius: 8)
            ],
            gradient: LinearGradient(
                end: const Alignment(0, 2),
                begin: const Alignment(0, -12),
                colors: [community.color, Colors.white])),
        child: InkWell(
          splashColor: community.color.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        PostDetailPage(post: post, community: community)))
                .then((value) =>
                    context.read<CommunityCubit>().checkAuthChange());
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                      fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.start)),
        ));
  }
}

class _CommunityMembersSection extends StatelessWidget {
  const _CommunityMembersSection(
      {required this.members,
      required this.color,
      required this.memberCount,
      required this.textColor,
      required this.communityId});

  final String communityId;
  final List<CommunityMember> members;
  final int memberCount;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _SectionTitle(
            text: 'Membres',
            subtitle: '$memberCount membres',
          ),
        ),
        SizedBox(
          height: 102,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            itemCount: members.length + 1,
            itemBuilder: (context, index) {
              if (index == members.length) {
                return InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return MemberListPage(
                            communityId: communityId, communityColor: color);
                      },
                    ));
                  },
                  child: Column(
                    children: [
                      MemberAvatar(
                        color: Theme.of(context).colorScheme.secondary,
                        name: '+',
                        foregroundColor: textColor,
                      ),
                      const SizedBox(height: 4),
                      const SizedBox(
                          width: 80,
                          child: Text('Veure tots',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis))
                    ],
                  ),
                );
              }
              final member = members[index];
              return _CommunityMemberWidget(
                  member: member, color: color, textColor: textColor);
            },
          ),
        )
      ],
    );
  }
}

class _CommunityMemberWidget extends StatelessWidget {
  const _CommunityMemberWidget(
      {required this.member, required this.color, required this.textColor});

  final CommunityMember member;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MemberAvatar(
          color: color,
          name: member.name,
          foregroundColor: textColor,
        ),
        const SizedBox(height: 4),
        SizedBox(
            width: 80,
            child: Text(member.shortName,
                textAlign: TextAlign.center, overflow: TextOverflow.ellipsis))
      ],
    );
  }
}

class _CommunityInfoSection extends StatelessWidget {
  const _CommunityInfoSection({required this.details});

  final CommunityDetails details;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _SectionTitle(text: 'Informació'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 5),
                      blurRadius: 8)
                ]),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                  child: CachedNetworkImage(
                    height: 170,
                    width: double.infinity,
                    fadeInDuration: 200.ms,
                    fadeOutDuration: 200.ms,
                    fit: BoxFit.cover,
                    imageUrl: details.mapUrl(),
                    placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                            Container(color: details.color.withOpacity(0.1))),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
                const SizedBox(height: 8),
                if (details.pais != null)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.public),
                    title: const Text('País',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    trailing: Text(details.pais ?? '',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                  ),
                ...details.info.entries.map((e) {
                  return ListTile(
                    dense: true,
                    leading: Icon(e.key.icon()),
                    title: Text(e.key.title(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    trailing: Text(e.value,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CommunityPageSkeleton extends StatefulWidget {
  const _CommunityPageSkeleton({required this.community});

  final Community community;

  @override
  State<_CommunityPageSkeleton> createState() => _CommunityPageSkeletonState();
}

class _CommunityPageSkeletonState extends State<_CommunityPageSkeleton>
    with SingleTickerProviderStateMixin {
  Color get color {
    return widget.community.color;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Opacity(
                    opacity: 0.2, child: _SectionTitle(text: 'Membres')),
              ),
              SizedBox(
                height: 102,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withAlpha(90), width: 8),
                              color: color.withOpacity(0.1)),
                          child: const SizedBox(),
                        ),
                        const SizedBox(height: 4),
                      ],
                    );
                  },
                ).shimmerLoop(),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child:
                    Opacity(opacity: 0.2, child: _SectionTitle(text: 'Tauler')),
              ),
              SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: color.withOpacity(0.1)),
                        ),
                      );
                    },
                  )).shimmerLoop()
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child:
                Opacity(opacity: 0.2, child: _SectionTitle(text: 'Informació')),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
                    color: color.withOpacity(0.1)),
              ).shimmerLoop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text, this.subtitle});

  final String text;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(fontWeight: FontWeight.w300),
              )
            : const SizedBox()
      ],
    );
  }
}
