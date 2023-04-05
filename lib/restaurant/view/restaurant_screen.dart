import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_factory/common/const/data.dart';
import 'package:flutter_code_factory/restaurant/component/restaurant_card.dart';
import 'package:flutter_code_factory/restaurant/model/restaurant_model.dart';
import 'package:flutter_code_factory/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];
                  final pItem = RestaurantModel.fromJson(json: item);

                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailScreen(id: pItem.id),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(model: pItem));
                },
                separatorBuilder: (_, index) => SizedBox(
                  height: 8.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
