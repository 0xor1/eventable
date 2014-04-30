/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

abstract class IEvent{
  EventEmitter get originalEmitter;
  EventEmitter get currentEmitter;
}