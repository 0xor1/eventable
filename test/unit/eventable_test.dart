/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library eventable.test;

import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:eventable/eventable.dart';

part 'event_emitter_test.dart';
part 'event_test.dart';
part 'event_detector_test.dart';

class TypeA{}
class TypeB{}

EventEmitter emitter1;
EventEmitter emitter2;
EventDetector detector;

Event lastDetectedEvent;
int eventADetectedCount;
int eventBDetectedCount;

EventAction detectEvent = (event){
  if(event.data is TypeA){
    eventADetectedCount++;
  }
  else if(event.data is TypeB){
    eventBDetectedCount++;
  }
  lastDetectedEvent = event;
};

void setUpTestObjects(){
  emitter1 = new EventEmitter();
  emitter2 = new EventEmitter();
  detector = new EventDetector();

  eventADetectedCount = eventBDetectedCount = 0;

  detector.listen(emitter1, TypeA, detectEvent);
  detector.listen(emitter2, TypeB, detectEvent);
}

void tearDownTestObjects(){
  emitter1 = emitter2 = detector = lastDetectedEvent = null;
  eventADetectedCount = eventBDetectedCount = 0;
}

void main(){
  setUp(setUpTestObjects);
  tearDown(tearDownTestObjects);
  runEventEmitterTests();
  runEventTests();
  runEventDetectorTests();
}