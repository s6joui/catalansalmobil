import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/community/model/community_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'member_list_state.dart';

class MemberListCubit extends Cubit<MemberListState> {
  final CommunityRepository _communityRepository;

  List<CommunityMember> results = [];

  MemberListCubit(this._communityRepository) : super(InitMemberListState());

  Future<void> fetchCommunityMembers(String communityId) async {
    emit(LoadingMemberListState());
    try {
      final response =
          await _communityRepository.getCommunityMembers(communityId);
      results = response.membres;
      await Future.delayed(const Duration(seconds: 1));
      emit(ResponseMemberListState(results: results));
    } catch (error) {
      emit(ErrorMemberListState(message: error.toString()));
    }
  }

  Future<void> search(String query) async {
    final searchResults = results
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(ResponseMemberListState(results: searchResults));
  }
}
