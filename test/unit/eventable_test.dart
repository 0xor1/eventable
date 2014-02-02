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

const String TYPE_A = 'type_a';
const String TYPE_B = 'type_b';

EventEmitter emitter1;
EventEmitter emitter2;
EventDetector detector;

Event lastDetectedEvent;
int eventADetectedCount;
int eventBDetectedCount;

EventAction detectEvent = (event){
  if(event.type == TYPE_A){
    eventADetectedCount++;
  }
  else if(event.type == TYPE_B){
    eventBDetectedCount++;
  }
  lastDetectedEvent = event;
  //print('event detected');
};

void setUpTestObjects(){
  emitter1 = new EventEmitter();
  emitter2 = new EventEmitter();
  detector = new EventDetector();

  eventADetectedCount = eventBDetectedCount = 0;

  detector.listen(emitter1, TYPE_A, detectEvent);
  detector.listen(emitter2, TYPE_B, detectEvent);
}

void tearDownTestObjects(){
  emitter1 = emitter2 = detector = lastDetectedEvent = null;
  eventADetectedCount = eventBDetectedCount = 0;
}

void main(){

  runEventEmitterTests();
  runEventTests();
  runEventDetectorTests();

}