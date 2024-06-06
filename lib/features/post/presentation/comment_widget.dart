import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/post/cubit/comment_cubit.dart';
import 'package:catalansalmon_flutter/features/post/cubit/comment_state.dart';
import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';
import 'package:catalansalmon_flutter/widgets/cam_text_field.dart';
import 'package:catalansalmon_flutter/widgets/cta_button.dart';
import 'package:catalansalmon_flutter/widgets/encircled_icon.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCreateWidget extends StatefulWidget {
  const PostCreateWidget(
      {super.key,
      required this.communityId,
      required this.postId,
      this.commentResultHandler});

  final String communityId;
  final String postId;
  final void Function(List<PostComment>?)? commentResultHandler;

  @override
  State<PostCreateWidget> createState() => _PostCreateWidgetState();
}

class _PostCreateWidgetState extends State<PostCreateWidget> {
  final _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = CommunityRepository();
        final authRepo = context.read<AuthRepository>();
        return CommentCubit(authRepo, repo, widget.communityId, widget.postId);
      },
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<CommentCubit, CommentState>(
                  listener: ((context, state) {
                if (state is SuccessCommentState) {
                  widget.commentResultHandler?.call(state.comments);
                }
              }), builder: (context, state) {
                if (state is ErrorCommentState) {
                  return SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const EncircledIcon(icon: Icons.priority_high)
                              .animate()
                              .scale(),
                          const SizedBox(height: 16),
                          const Text('Hi ha hagut un error. Prova-ho de nou.',
                                  textAlign: TextAlign.center)
                              .animate()
                              .fadeIn(),
                          const SizedBox(height: 48),
                          SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      child: const Text('Torna-ho a provar')))
                              .animate()
                              .fadeIn(),
                        ],
                      )));
                }
                if (state is SendingCommentState) {
                  return const SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(child: GlobeLogo()));
                }
                if (state is SuccessCommentState) {
                  return SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const EncircledIcon(icon: Icons.check)
                              .animate()
                              .scale(),
                          const SizedBox(height: 16),
                          const Text('El comentari s\'ha enviat correctament!')
                              .animate()
                              .fadeIn(),
                          const SizedBox(height: 48),
                          SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      child: const Text('Continua')))
                              .animate()
                              .fadeIn(),
                        ],
                      )));
                }
                return SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const SizedBox(height: 16),
                      const Text('Escriu el teu comentari:'),
                      const SizedBox(height: 16),
                      CAMTextField(
                          keyboardType: TextInputType.multiline,
                          autofocus: true,
                          maxLines: null,
                          controller: _commentTextController),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Spacer(),
                          CtaButton(
                            title: 'Envia',
                            color: Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            icon: Icons.arrow_forward,
                            onPressed: () {
                              if (_commentTextController.text.isEmpty) {
                                return;
                              }
                              context
                                  .read<CommentCubit>()
                                  .createComment(_commentTextController.text);
                            },
                          ),
                        ],
                      ),
                    ]));
              }))),
    );
  }
}
