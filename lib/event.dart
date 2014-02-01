/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

/**
 * An extendable [Json_Object] used to pass information to [EventAction]s about
 * the current [Event] being emitted.
 */
class Event extends JsonObject implements IEvent{}
abstract class IEvent{
  String type;
  EventEmitter emitter;
}