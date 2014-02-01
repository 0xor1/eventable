#Eventable [![Build Status](https://drone.io/github.com/0xor1/eventable/status.png)](https://drone.io/github.com/0xor1/eventable/latest)

Eventable provides 2 mixins to make your classes eventable, **EventEmitter** and
**EventDetector**. Simply use these mixins to make your types either *emit*,
*detect* or do *both* for *custom events*. To make a custom event simply extend 
off of the **Event** class and specify an interface implementation, but you do 
not have to implement it as **Event** is in fact a [Json_Object](https://github.com/chrisbu/dartwatch-JsonObject).
One final note to be aware of is that events are emitted asynchronously. Usage is
best described with a simple example:

##Example

```dart
class Dog extends Object with EventEmitter{

  static const String BARK = 'dog_bark';

  void bark(int volume){
    emitEvent(
        BARK,
        new BarkEvent()
        ..volume = volume);
  }
  
}

class Cat extends Object with EventDetector{

  void dogBarkHandler(BarkEvent event){
    if(event.volume > 10){
      runaway();
    }else{
      print('cat not disturbed');
    }
  }

  void runaway(){
    print('cat running away');
  }

}

class BarkEvent extends Event implements IBarkEvent{}
abstract class IBarkEvent{
  int volume;
}

void main(){

  var dog = new Dog();
  var cat = new Cat();

  cat.listen(dog, Dog.BARK, cat.dogBarkHandler);

  dog.bark(9);  // cat not disturbed
  dog.bark(11); // cat runs away

}
```

##OMNI

There is a special event type called **OMNI** which is a top level string constant
in the eventable library which has the value ```'omni'```, this is a special value
which allows you to listen to every event emitted by an **EventEmitter** with a
single **EventAction**, therefore it is strongly recommended when implementing your
own event types you do not use 'omni' or you may find incorrect program behaviour
as a result of doing so.

##EventAction

A ```typedef``` is specified in the eventable library which
serves as the function signature accepted as the last argument to an **EventDetector**s
```listen``` method. The signature is:

```dart
typedef void EventAction(Event event);
```

##DuplicateEventSettingError

A given **EventDetector** can only listen to a specific event type from a specific
**EventEmitter** once, therefore it is an error to try to attach more **EventAction**s
to the same **EventEmitter**/event type combination. If a second attempt is made
by an **EventDetector** to listen to the same **EventEmitter**/event type combination
a **DuplicateEventSettingError** will be thrown.

##EmitTimeQueueChangeError

It is not permitted to add or remove **EventAction**s whilst the event is being
emitted, meaning you may not attach an **EventAction** to an event which adds or
removes *EventAction**s from that same event, if such an attempt is made a 
**EmitTimeQueueChangeError** will be thrown.