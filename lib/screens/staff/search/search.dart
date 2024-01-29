import 'package:alemagro_application/blocs/search/search_bloc.dart';
import 'package:alemagro_application/blocs/search/search_event.dart';
import 'package:alemagro_application/blocs/search/search_state.dart';
import 'package:alemagro_application/screens/staff/client/clientProfile/client_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySearchWidget extends StatefulWidget {
  @override
  _MySearchWidgetState createState() => _MySearchWidgetState();
}

class _MySearchWidgetState extends State<MySearchWidget> {
  TextEditingController _controller = TextEditingController();
  bool _searchAttempted = true; // переменная для отслеживания попытки поиска
  @override
  void initState() {
    _controller.dispose();
    super.initState();
    _controller = TextEditingController();
  }

  void _performSearch(dynamic text) {
    if (text.isEmpty) {
      return;
    }

    final numericId = int.tryParse(text);

    if (numericId != null) {
      BlocProvider.of<ClientSearchBloc>(context)
          .add(ClientSearchById(id: numericId));
    } else {
      BlocProvider.of<ClientSearchBloc>(context)
          .add(ClientSearchByName(name: text));
    }
  }

  void _onSearchButtonPressed() {
    setState(() {
      _searchAttempted = true; // обновляем состояние при попытке поиска
    });

    if (_controller.text.isNotEmpty) {
      BlocProvider.of<ClientSearchBloc>(context)
          .add(ClientSearchTextChanged(searchText: _controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        suffixIcon: _controller.text.isEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _controller
                                      .clear(); // Очищает текст в TextField
                                  // Также обновите состояние, чтобы иконка крестика исчезла
                                  setState(() {});
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _controller
                                      .clear(); // Очищает текст в TextField
                                  // Также обновите состояние, чтобы иконка крестика исчезла
                                  setState(() {});
                                },
                              ),
                        labelText:
                            'Введите наименование клиента / либо ИИН-БИН'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ClientSearchBloc, ClientSearchState>(
              builder: (context, state) {
                if (_controller.text.isEmpty && _searchAttempted) {
                  return Center(
                    child: Image.asset(
                      'assets/search_illustrate.png',
                      opacity: const AlwaysStoppedAnimation(
                          .4), //Animation for search illustration
                    ),
                  );
                } else if (state is ClientSearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ClientSearchSuccess) {
                  return ListView.builder(
                    itemCount: state.clients.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          child: Container(
                            child: ListTile(
                              title: Text(
                                  state.clients[index].name ?? 'Нет имени'),
                              subtitle: Text(
                                  state.clients[index].iinBin ?? 'Нет БИН'),
                              // Другие поля клиента, если необходимо
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ClientProfile(
                                            data: state.clients[index])));
                          });
                    },
                  );
                }
                if (state is ClientSearchFailure) {
                  return Text('Ошибка: ${state.error}');
                }
                return Container(); // Состояние по умолчанию
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
