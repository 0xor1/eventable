part of Eventable;

class Event extends JsonObject implements IEvent{}
abstract class IEvent{
  String type;
  Eventable emitter;
}