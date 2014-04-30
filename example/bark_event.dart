/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableExample;

class BarkEvent extends Event implements IBarkEvent{}
abstract class IBarkEvent{
  int volume;
}