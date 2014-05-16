/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of eventable.example;

class Dog extends Object with EventEmitter{
  void bark(int volume){
    emitEvent(new Bark(volume));
  }
}