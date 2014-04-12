#Eventable [![Build Status](https://drone.io/github.com/0xor1/eventable/status.png)](https://drone.io/github.com/0xor1/eventable/latest)

Eventable provides 2 mixins to make your classes eventable, **EventEmitter** and
**EventDetector**. Simply use these mixins to make your types either *emit*,
*detect* or do *both* for *custom events*. To make a custom event simply extend 
off of the **Event** class and specify an interface implementation, but you do 
not have to implement it as **Event** is in fact a [Transmittable](http://pub.dartlang.org/packages/transmittable).
One final note to be aware of is that events are emitted asynchronously. Usage is
best described with a simple example:

##Example

```dart
class Dog extends Object with EventEmitter{

  void bark(int volume){
    emitEvent(
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

class BarkEvent implements IEvent{
  EventEmitter emitter;
  int volume;
}

void main(){

  var dog = new Dog();
  var cat = new Cat();

  cat.listen(dog, BarkEvent, cat.dogBarkHandler);

  dog.bark(9);  // cat not disturbed
  dog.bark(11); // cat runs away

}
```

**Eventable** was designed to allow objects to interact in a loose and non coupled way.
The typical usage pattern is to have a *model* as an **EventEmitter** and
one or more *views* as **EventDetector**s of that model, listening to it via its asynchronous
events. This way the model operates completely independently of the views and views
are easily discarded by calling ```aView.ignoreAllEvents();``` which will fully detach
all of the views EventActions, for all event types and **EventEmitter**s.

It is still possible and perfectly legal to use **EventEmitter**s without **EventDetector**s
as they expose their own ```addEventAction``` and ```removeEventAction``` methods,
but this leaves it to the user to handle how to manage removal of the attached **EventAction**s.

##Omni

There is a special event type **Omni** which is a special value
which allows you to listen to every event emitted by an **EventEmitter** with a
single **EventAction**.

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
removes **EventAction**s from that same event, if such an attempt is made a 
**EmitTimeQueueChangeError** will be thrown.