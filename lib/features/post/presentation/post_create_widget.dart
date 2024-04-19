
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/post/cubit/post_create_cubit.dart';
import 'package:catalansalmon_flutter/features/post/cubit/post_create_state.dart';
import 'package:catalansalmon_flutter/features/post/data/posts_repo.dart';
import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';
import 'package:catalansalmon_flutter/widgets/cam_text_field.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCreateWidget extends StatefulWidget {
  const PostCreateWidget({super.key, required this.communityId, required this.postId, this.commentResultHandler});

  final String communityId;
  final String postId;
  final void Function(List<PostComment>?)? commentResultHandler;

  @override
  State<PostCreateWidget> createState() =>
      _PostCreateWidgetState();
}

class _PostCreateWidgetState extends State<PostCreateWidget> {
  final _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = PostsRepository();
        final authRepo = context.read<AuthRepository>();
        return PostCreateCubit(authRepo, repo, widget.communityId, widget.postId);
      },
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<PostCreateCubit,PostCreateState>(
                listener: ((context, state) {
                  if (state is SuccessPostCreateState) {
                    widget.commentResultHandler?.call(state.comments);
                  }
                }),
                builder: (context, state) {
                if (state is ErrorPostCreateState) {
                  return SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3),
                                  ),
                                  child:
                                      const Icon(Icons.priority_high, size: 40))
                              .animate()
                              .scale(),
                          const SizedBox(height: 16),
                          const Text(
                                  'Hi ha hagut un error. Prova-ho de nou.',
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
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white),
                                      child: const Text('Torna-ho a provar')))
                              .animate()
                              .fadeIn(),
                        ],
                      )));
                }
                if (state is SendingPostCreateState) {
                  return const SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(child: GlobeLogo()));
                }
                if (state is SuccessPostCreateState) {
                  return SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3),
                                  ),
                                  child: const Icon(Icons.check, size: 40))
                              .animate()
                              .scale(),
                          const SizedBox(height: 16),
                          const Text('El comentari s\'ha enviat correctament!').animate().fadeIn(),
                          const SizedBox(height: 48),
                          SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white),
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
                      SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_commentTextController.text.isEmpty) {
                                  return;
                                }
                                context.read<PostCreateCubit>().createComment(_commentTextController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white),
                              child: const Text('Envia'))),
                    ]
                  )
                );
              })
          )),
    );
  }
}
