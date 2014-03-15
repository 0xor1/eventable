/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

/**
 * An extendable [Transmittable] used to pass information to [EventAction]s about
 * the current [Event] being emitted.
 */
class Event extends Transmittable implements IEvent{}
abstract class IEvent{
  Type type;
  EventEmitter emitter;
}