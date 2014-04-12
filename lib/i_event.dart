/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

/**
 * Every event must implement [IEvent]
 */
abstract class IEvent{
  EventEmitter emitter;
}