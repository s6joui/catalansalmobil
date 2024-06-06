import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/community/cubit/create_post_cubit.dart';
import 'package:catalansalmon_flutter/features/community/cubit/create_post_state.dart';
import 'package:catalansalmon_flutter/widgets/cam_text_field.dart';
import 'package:catalansalmon_flutter/widgets/cta_button.dart';
import 'package:catalansalmon_flutter/widgets/encircled_icon.dart';
import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget(
      {super.key, this.postResultHandler, required this.communityId});

  final String communityId;
  final void Function()? postResultHandler;

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final _titleTextController = TextEditingController();
  final _bodyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = CommunityRepository();
        final authRepo = context.read<AuthRepository>();
        return CreatePostCubit(authRepo, repo, widget.communityId);
      },
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<CreatePostCubit, CreatePostState>(
                  listener: ((context, state) {
                if (state is SuccessCreatePostState) {
                  widget.postResultHandler?.call();
                }
              }), builder: (context, state) {
                if (state is ErrorCreatePostState) {
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
                if (state is SendingCreatePostState) {
                  return const SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Center(child: GlobeLogo()));
                }
                if (state is SuccessCreatePostState) {
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
                          const Text('El post s\'ha enviat correctament!')
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
                      const Text('Escriu el teu missatge:'),
                      const SizedBox(height: 16),
                      CAMTextField(
                        hintText: 'Títol',
                        autofocus: true,
                        controller: _titleTextController,
                      ),
                      const SizedBox(height: 8),
                      CAMTextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          hintText: 'Contingut',
                          textInputAction: TextInputAction.newline,
                          showsClearButton: false,
                          controller: _bodyTextController),
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
                                context.read<CreatePostCubit>().createPost(
                                    _titleTextController.text,
                                    _bodyTextController.text);
                              }),
                        ],
                      ),
                    ]));
              }))),
    );
  }
}
