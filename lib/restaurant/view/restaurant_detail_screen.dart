import 'package:flutter/material.dart';
import 'package:flutter_code_factory/common/layout/default_layout.dart';
import 'package:flutter_code_factory/product/component/product_card.dart';
import 'package:flutter_code_factory/restaurant/component/restaurant_card.dart';
import 'package:flutter_code_factory/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_code_factory/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  const RestaurantDetailScreen({
    super.key,
    required this.id,
  });

  // Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
  //   return ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          print(snapshot.data);
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // final item = RestaurantDetailModel.fromJson(snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts({required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(
                model: model,
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text('메뉴'),
      ),
    );
  }
}
