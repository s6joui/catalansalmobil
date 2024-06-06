import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/auth/presentation/login_page.dart';
import 'package:catalansalmon_flutter/features/community/model/community_post.dart';
import 'package:catalansalmon_flutter/features/post/cubit/post_cubit.dart';
import 'package:catalansalmon_flutter/features/post/cubit/post_state.dart';
import 'package:catalansalmon_flutter/features/post/presentation/comment_widget.dart';
import 'package:catalansalmon_flutter/model/community.dart';
import 'package:catalansalmon_flutter/widgets/cta_button.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage(
      {super.key, required this.post, required this.community});

  final Community community;
  final CommunityPost post;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Color get labelColor {
    return Theme.of(context).brightness == Brightness.dark
        ? widget.community.lighterColor
        : widget.community.color;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          final repo = CommunityRepository();
          final authRepo = context.read<AuthRepository>();
          final cubit =
              PostCubit(authRepo, repo, widget.community.id, widget.post);
          cubit.fetchComments();
          return cubit;
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text(widget.post.date,
                            style: TextStyle(
                                color: labelColor,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 16),
                        Linkify(
                            options: const LinkifyOptions(humanize: false),
                            text: widget.post.body,
                            onOpen: (link) async {
                              if (!await launchUrl(Uri.parse(link.url))) {
                                throw Exception('Could not launch ${link.url}');
                              }
                            },
                            linkStyle: TextStyle(
                                color: labelColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    widget.community.lighterColor)),
                        const SizedBox(height: 16),
                        Text(
                          widget.post.user,
                          style: TextStyle(
                              color: labelColor, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 16),
                        _PostCommentsWidget(widget.community.color),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(),
                      BlocBuilder<PostCubit, PostState>(
                        builder: (context, state) {
                          if (state is! ResponsePostState) {
                            return const SizedBox();
                          }
                          return CtaButton(
                            title: 'Comenta',
                            color: widget.community.color,
                            foregroundColor: widget.community.onTopColor,
                            icon: Icons.message_outlined,
                            onPressed: () {
                              if (state.isLoggedIn) {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    builder: (innerContext) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(innerContext)
                                                .viewInsets
                                                .bottom),
                                        child: PostCreateWidget(
                                          communityId: widget.community.id,
                                          postId: widget.post.id,
                                          commentResultHandler: (comments) {
                                            if (comments == null) {
                                              return;
                                            }
                                            context
                                                .read<PostCubit>()
                                                .updateCommentList(comments);
                                          },
                                        ),
                                      );
                                    });
                              } else {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    builder: (innerContext) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(innerContext)
                                                .viewInsets
                                                .bottom),
                                        child: LoginPage(
                                          communityId: widget.community.id,
                                          loginResultHandler: (success) {
                                            context
                                                .read<PostCubit>()
                                                .checkAuthChange();
                                          },
                                        ),
                                      );
                                    });
                              }
                            },
                          ).animate().fadeIn();
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _PostCommentsWidget extends StatelessWidget {
  const _PostCommentsWidget(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text('Comentaris',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          if (state is ResponsePostState) {
            if (state.comments.isEmpty) {
              return const Text('No hi ha comentaris.');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: state.comments.map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(1, 1),
                                blurRadius: 3.0)
                          ],
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: color.withOpacity(0.2)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(c.comentari),
                        ),
                      )),
                );
              }).toList(),
            ).animate().fadeIn();
          }
          if (state is ErrorPostState) {
            return Text(state.message);
          }
          return const Center(child: GlobeLogo());
        })
      ],
    );
  }
}
