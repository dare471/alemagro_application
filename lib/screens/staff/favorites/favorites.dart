import 'dart:math';

import 'package:alemagro_application/blocs/favoritesClient/favorites_bloc.dart';
import 'package:alemagro_application/blocs/favoritesClient/favorites_event.dart';
import 'package:alemagro_application/blocs/favoritesClient/favorites_state.dart';
import 'package:alemagro_application/models/favorites/favorites.dart';
import 'package:alemagro_application/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../database/database_helper.dart';

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Избранные"),
        backgroundColor: AppColors.blueDarkV2,
      ),
      body: BlocProvider<FavoritesClientBloc>(
        create: (context) => FavoritesClientBloc(),
        child: FavoritesMainPage(),
      ),
    );
  }
}

class FavoritesMainPage extends StatefulWidget {
  @override
  _FavoritesMainPageState createState() => _FavoritesMainPageState();
}

class _FavoritesMainPageState extends State<FavoritesMainPage> {
  late final userProfileData; // Объявление переменной
  TextEditingController searchController = TextEditingController();
  bool isSortedByMargin = false;

  @override
  void initState() {
    super.initState();
    userProfileData =
        DatabaseHelper.getUserProfileData(); // Инициализация данных в initState
  }

  List<Favorites> filterAndSortFavorites(List<Favorites> favorites) {
    String searchQuery = searchController.text.toLowerCase();
    List<Favorites> filteredFavorites = favorites
        .where((favorite) =>
            favorite.clientName.toLowerCase().contains(searchQuery))
        .toList();

    if (isSortedByMargin) {
      for (var favorite in filteredFavorites) {
        favorite.yearlyData.sort((b, a) => a.margin.compareTo(b.margin));
      }
    }

    return filteredFavorites;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesClientBloc, FavoritesClientState>(
      builder: (context, state) {
        final FavoritesClientBloc favoritesClientBloc =
            BlocProvider.of<FavoritesClientBloc>(context);
        if (state is FavoritesInitialState) {
          favoritesClientBloc.add(FetchFavoritesClient(72));
        }

        List<Favorites> displayedFavorites =
            state is LoadedState ? filterAndSortFavorites(state.data) : [];

        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedState) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: searchController,
                  decoration:
                      InputDecoration(labelText: 'Поиск по имени клиента'),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              // IconButton(
              //   icon: Icon(isSortedByMargin ? Icons.sort : Icons.sort_by_alpha),
              //   onPressed: () => setState(() {
              //     isSortedByMargin = !isSortedByMargin;
              //   }),
              // ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: displayedFavorites.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return buildFavoriteCard(displayedFavorites[index]);
                  },
                ),
              ),
            ],
          );
        } else if (state is ErrorState) {
          return Text('Ошибка: ${state.message}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildFavoriteCard(Favorites favorite) {
    List<YearlyData> sortedYearlyData = List.from(favorite.yearlyData)
      ..sort((b, a) => a.year.compareTo(b.year)); // Сортировка по году

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      shadowColor: const Color.fromARGB(176, 3, 90, 166),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favorite.clientName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(10),
            Text('БИН\ИИН:  ${favorite.clientBin}'),
            Gap(8),
            Column(
              children: sortedYearlyData
                  .map((yearData) => _buildYearlyData(yearData))
                  .toList(),
            ),
            // Дополнительная информация
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.blueDarkV2,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {},
                child: // Дополнительное пространство
                    // ignore: prefer_const_constructors
                    Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.person_pin_outlined,
                      size: 25,
                      color: AppColors.offWhite,
                    ),
                    SizedBox(width: 8), // Отступ между иконкой и текстом
                    Text(
                      'Посмотреть профиль',
                      style: TextStyle(fontSize: 14, color: AppColors.offWhite),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyData(YearlyData yearlyData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                yearlyData.year,
                style: TextStyle(fontSize: 14),
              ),
              Gap(10),
              yearlyData.salesAmount == "0₸"
                  ? Expanded(child: Text("Продажи: Неизвестно"))
                  : Expanded(
                      child: Text(
                        'Продажи: ${yearlyData.salesAmount}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
              Gap(10),
              yearlyData.margin == 0.0
                  ? Expanded(child: Text("Маржа: Неизвестно"))
                  : Expanded(
                      child: Text(
                        'Маржа: ${yearlyData.margin}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
            ],
          ),
          Divider(
            color: AppColors.blueDarkV2,
            height: 10,
          )
        ],
      ),
    );
  }
}

Widget buildFavoritesList(BuildContext parentContext) {
  final userProfileData = DatabaseHelper.getUserProfileData();
  return BlocBuilder<FavoritesClientBloc, FavoritesClientState>(
    builder: (context, state) {
      final FavoritesClientBloc favoritesClientBloc =
          BlocProvider.of<FavoritesClientBloc>(context);
      if (state is FavoritesInitialState) {
        favoritesClientBloc.add(FetchFavoritesClient(
            72)); // Используйте ID пользователя из userProfileData
      }
      if (state is LoadingState) {
        return const CircularProgressIndicator();
      } else if (state is LoadedState) {
        return ListView.separated(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: min(state.data.length, 1),
          separatorBuilder: (context, index) =>
              Divider(height: 1), // Разделитель между элементами
          itemBuilder: (context, index) {
            var favorite = state.data[index];
            return Card(
              margin: EdgeInsets.all(8),
              elevation: 4,
              shadowColor: const Color.fromARGB(176, 3, 90, 166),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Количество избранных клиентов: ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          state.data.length.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.blueDarkV2),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Favorite()),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          Text("Посмотреть весь список")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      } else if (state is ErrorState) {
        return Text('Ошибка: ${state.message}');
      }
      return const CircularProgressIndicator(); // Начальное состояние или необработанное состояние
    },
  );
}
