abstract class PinEvent {}

class LoadPinEvent extends PinEvent {}

class DeletePinEvent extends PinEvent {}

class SavePinEvent extends PinEvent {
  final String pin;
  SavePinEvent(this.pin);
}
