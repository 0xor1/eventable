part of EventableExample;

class BarkEvent extends Event implements IBarkEvent{}
abstract class IBarkEvent{
  int volume;
}