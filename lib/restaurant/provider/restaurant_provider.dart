import 'package:flutter_code_factory/common/model/cursor_pagination_model.dart';
import 'package:flutter_code_factory/common/model/pagination_params.dart';
import 'package:flutter_code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final respository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: respository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    // final resp = await repository.paginate();
    // state = resp;

    // State 상태의 5가지 가능성
    // 1) CursorPagination -> 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading -> 데이터가 로딩중인 상태(현재 캐시 없음)
    // 3) CursorPaginationError -> 에러가 발생한 상태
    // 4) CursorPaginationRefetching -> 첫번째 페이지부터 다시 데이터를 가져올때
    // 5) CursorPaginationFetchingMore -> 데이터를 추가로 가져오는 중인 상태

    // 바로 반환하는 상황
    // 1) hasMore == false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
    // 2) 로딩중 -> fetchMore == true
    //    fetchMore가 아닐때 - 새로고침의 의도가 있다/있을 수 있다
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(after: pState.data.last.id);
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 FETCH (API 요청)을 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터에
        // 새로운 데이터 추가
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CusrorPaginationError(message: e.toString());
    }
  }
}
