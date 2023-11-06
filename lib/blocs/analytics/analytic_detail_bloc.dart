import 'dart:convert';
import 'package:alemagro_application/blocs/analytics/analytic_event.dart';
import 'package:alemagro_application/blocs/analytics/analytic_state.dart';
import 'package:alemagro_application/models/analytic_detail_user.dart';
import 'package:alemagro_application/screens/staff/analytics/widget_main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AnalyticDetailBloc
    extends Bloc<AnalyticDetailEvent, AnalyticDetailState> {
  AnalyticDetailBloc() : super(AnalyticDetailInitial());

  Future<List<dynamic>> fetchAnalytic() async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/workspace/mobile'),
      body: jsonEncode(
          {"type": "planFactUser", "target": authData['user']['id']}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Stream<AnalyticDetailState> mapEventToState(
      AnalyticDetailEvent event) async* {
    if (event is FetchAnalytic) {
      try {
        var rawData = await fetchAnalytic();
        // Преобразование rawData в List<Map<String, dynamic>> для последующего преобразования в объекты UserAnalytic.
        List<Map<String, dynamic>> jsonData =
            List<Map<String, dynamic>>.from(rawData);
        // Создание списка объектов UserAnalytic из сырых JSON данных.
        UserAnalyticsList analytics = UserAnalyticsList.fromJSON(jsonData);
        // Если данные успешно получены и обработаны, мы отправляем состояние с этими данными.
        yield AnalyticDetailFetched(analytics
            .analytics); // предполагая, что у вас есть состояние, которое принимает List<UserAnalytic>
      } catch (error) {
        // Вы можете добавить новое состояние ошибки, чтобы обрабатывать ошибки.
        yield AnalyticDetailError('Failed to fetch analytics: $error');
      }
    }
  }
}
