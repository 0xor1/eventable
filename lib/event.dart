/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

class Event extends JsonObject implements IEvent{}
abstract class IEvent{
  String type;
  EventEmitter emitter;
}