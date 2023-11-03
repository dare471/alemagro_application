import 'package:alemagro_application/blocs/pincode/pin_code_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinBloc extends Bloc<PinEvent, String> {
  final _storage = FlutterSecureStorage();

  PinBloc() : super('') {
    on<LoadPinEvent>((event, emit) async {
      emit(await _storage.read(key: 'pincode') ?? '');
    });

    on<SavePinEvent>((event, emit) async {
      await _storage.write(key: 'pincode', value: event.pin);
      emit(event.pin);
    });

    on<DeletePinEvent>((event, emit) async {
      await _storage.delete(key: 'pincode');
      emit('');
    });
  }
}
