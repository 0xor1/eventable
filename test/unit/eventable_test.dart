/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library EventableTest;

import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:eventable/eventable.dart';

part 'event_emitter_test.dart';
part 'event_test.dart';
part 'event_detector_test.dart';

class TypeA extends Event{}
class TypeB extends Event{}

class Eventable extends Object with EventEmitter, EventDetector{}

Eventable relay;
EventEmitter emitter1;
EventEmitter emitter2;
EventDetector detector;

Event lastDetectedEvent;
Event lastRelayedEvent;
int eventADetectedCount;
int eventBDetectedCount;

EventAction detectEvent = (event){
  if(event is TypeA){
    eventADetectedCount++;
  }
  else if(event is TypeB){
    eventBDetectedCount++;
  }
  lastDetectedEvent = event;
};

void setUpTestObjects(){
  relay = new Eventable();
  emitter1 = new EventEmitter();
  emitter2 = new EventEmitter();
  detector = new EventDetector();

  eventADetectedCount = eventBDetectedCount = 0;

  relay.listen(emitter1, Omni, (event){
    lastRelayedEvent = event;
    relay.emitEvent(event);
  });
  relay.listen(emitter2, Omni, (event){
    lastRelayedEvent = event;
    relay.emitEvent(event); 
  });
  detector.listen(relay, TypeA, detectEvent);
  detector.listen(relay, TypeB, detectEvent);
}

void tearDownTestObjects(){
  emitter1 = emitter2 = detector = lastDetectedEvent = null;
  eventADetectedCount = eventBDetectedCount = 0;
}

void expectAsyncWithReadyCheckAndTimeout(bool readyCheck(), void expect(), [int timeout = 1, void onTimeout() = null]){
  DateTime start = new DateTime.now();
  Duration limit = new Duration(seconds: timeout);
  var inner;
  inner = (){
    if(readyCheck()){
      expect();
    }else if(new DateTime.now().subtract(limit).isAfter(start)){
      if(onTimeout == null){
        throw 'async test timed out';
      }else{
        onTimeout();
      }
    }else{
      Timer.run(expectAsync(inner));
    }
  };
  inner();
}

void main(){

  setUp(setUpTestObjects);
  tearDown(tearDownTestObjects);
  runEventEmitterTests();
  runEventTests();
  runEventDetectorTests();

}