/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableExample;

class BarkEvent implements IEvent{
  EventEmitter emitter;
  int volume;
}