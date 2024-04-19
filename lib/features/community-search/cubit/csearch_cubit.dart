import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/community-search/cubit/csearch_state.dart';
import 'package:catalansalmon_flutter/model/community.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunitySearchCubit extends Cubit<CommunitySearchState> {

  final CommunityRepository _communityRepository;

  List<Community> results = [];

  CommunitySearchCubit(this._communityRepository) : super(InitCommunitySearchState());

  Future<void> fetchAllCommunities() async {
    emit(LoadingCommunitySearchState());
    try {
      results = await _communityRepository.getAllCommunities();
      await Future.delayed(const Duration(seconds: 1));
      emit(ResponseCommunitySearchState(results: results));
    } catch (error) {
      emit(ErrorCommunitySearchState(message: error.toString()));
    }
  }

  Future<void> search(String query) async {
    final searchResults = results.where((element) => element.nom.toLowerCase().contains(query.toLowerCase())).toList();
    emit(ResponseCommunitySearchState(results: searchResults));
  }
}