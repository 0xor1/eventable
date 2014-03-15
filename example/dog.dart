/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableExample;

class Dog extends Object with EventEmitter{

  void bark(int volume){
    emitEvent(
        BarkEvent,
        new BarkEvent()
        ..volume = volume);
  }

}