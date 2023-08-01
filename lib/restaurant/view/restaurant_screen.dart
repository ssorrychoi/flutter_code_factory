import 'package:flutter/material.dart';
import 'package:flutter_code_factory/common/model/cursor_pagination_model.dart';
import 'package:flutter_code_factory/restaurant/component/restaurant_card.dart';
import 'package:flutter_code_factory/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() {
      scrollListner();
    });
  }

  void scrollListner() {
    // 현재 위치가 최대 길이보다 좀 덜되는 위치까지 왔다면 새로운 데이터를 추가요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (data is CusrorPaginationError) {
      return Center(child: Text(data.message));
    }

    // if (data.length == 0) {
    //   return Center(child: CircularProgressIndicator());
    // }

    final cp = data as CursorPagination;

    return Container(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            controller: controller,
            itemCount: cp.data.length + 1,
            itemBuilder: (_, index) {
              if (index == cp.data.length) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                    child: data is CursorPaginationFetchingMore ? const CircularProgressIndicator() : const Text('마지막 데이터 입니다 ㅜㅜ'),
                  ),
                );
              }
              final pItem = cp.data[index];
              // final pItem = RestaurantModel.fromJson(item);

              return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(id: pItem.id),
                      ),
                    );
                  },
                  child: RestaurantCard.fromModel(model: pItem));
            },
            separatorBuilder: (_, index) => SizedBox(
              height: 8.0,
            ),
          ),
        ),
      ),
    );
  }
}
