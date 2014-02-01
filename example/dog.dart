/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableExample;

class Dog extends Object with EventEmitter{

  static const String BARK = 'dog_bark';

  void bark(int volume){
    emitEvent(
        BARK,
        new BarkEvent()
        ..volume = volume);
  }

}