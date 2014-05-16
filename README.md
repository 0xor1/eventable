#Eventable [![Build Status](https://drone.io/github.com/0xor1/eventable/status.png)](https://drone.io/github.com/0xor1/eventable/latest)

Eventable provides 2 mixins to make your classes eventable, **EventEmitter** and
**EventDetector**. Simply use these mixins to make your types either *emit*,
*detect* or do *both* for *asynchronous events*. An **Event** can carry any **data** object, 
to listen for an **Event** carrying a particular data type just **listen** for that
*data type*. Usage is best described with a simple example:

##Example

```dart
class Dog extends Object with EventEmitter{

  void bark(int volume){
    emitEvent(new Bark(volume));
  }
  
}

class Cat extends Object with EventDetector{

  void dogBarkHandler(Event event){
    var bark = event.data as Bark;
    if(bark.volume > 10){
      runaway();
    }else{
      print('cat not disturbed');
    }
  }

  void runaway(){
    print('cat running away');
  }

}

class Bark{
  final int volume;
  Bark(this.volume);
}

void main(){

  var dog = new Dog();
  var cat = new Cat();

  cat.listen(dog, Bark, cat.dogBarkHandler);

  dog.bark(9);  // cat not disturbed
  dog.bark(11); // cat runs away

}
```

##Omni

There is a special event data type **Omni** which allows detectors to listen to every event emitted
by an **EventEmitter** with a single **EventAction**.

##EventAction

A ```typedef``` is specified in the eventable library which
serves as the function signature accepted as the last argument to an **EventDetector**s
```listen``` method. The signature is:

```dart
typedef void EventAction(Event event);
```

##DuplicateEventSettingError

A given **EventDetector** can only listen to a specific event-data-type from a specific
**EventEmitter** once, therefore it is an error to try to attach more **EventAction**s
to the same **EventEmitter**/event-data-type combination. If a second attempt is made
by an **EventDetector** to listen to the same **EventEmitter**/event-data-type combination
a **DuplicateEventSettingError** will be thrown.

##EmitTimeQueueChangeError

It is not permitted to add or remove **EventAction**s whilst the event is being
emitted, meaning you may not attach an **EventAction** to an event which adds or
removes **EventAction**s from that same event-data-type queue, if such an attempt is made a 
**EmitTimeQueueChangeError** will be thrown. to remove **EventAction**s for an emitting **Event**
it is best to do so in the **finished** **Future** property on the **Event** object.