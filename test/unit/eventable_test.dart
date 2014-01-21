library EventableTest;

import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:eventable/eventable.dart';

void main(){

  group('', (){

    const String TYPE_A = 'type_a';
    const String TYPE_B = 'type_b';

    Emitter emitter1;
    Emitter emitter2;
    Detector detector;

    Event lastDetectedEvent;
    int eventADetectedCount = 0;
    int eventBDetectedCount = 0;

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

    setUp((){
      emitter1 = new Emitter();
      emitter2 = new Emitter();
      detector = new Detector();

      detector.listen(emitter1, TYPE_A, detectEvent);
      detector.listen(emitter2, TYPE_B, detectEvent);
    });

    tearDown((){
      emitter1 = emitter2 = detector = lastDetectedEvent = null;
      eventADetectedCount = eventBDetectedCount = 0;
    });

    test('EventActions are called asynchronously', (){
      emitter1.emitEvent(TYPE_A);
      expect(lastDetectedEvent, equals(null));
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('Events contain the emitter object', (){
      emitter1.emitEvent(TYPE_A);
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('Events contain the event type string', (){
      emitter1.emitEvent(TYPE_A);
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.type, equals(TYPE_A));
      }));
    });

    test('Events are extendable, meaning new properties can be added to them at anytime', (){
      emitter1.emitEvent(
          TYPE_A,
          new Event()
          ..meaningOfLife = 42
          ..crazyString = 'a_crazy_string'
      );
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.meaningOfLife, equals(42));
        expect(lastDetectedEvent.crazyString, equals('a_crazy_string'));
      }));
    });

    test('Detector.ignore() unhooks all EventActions', (){
      detector.ignore();
      emitter1.emitEvent(TYPE_A);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(0));
      }));
    });

    test('Detector.ignore(type:eventType) unhooks all EventActions of the specified type', (){
      detector.ignore(type: TYPE_A);
      emitter1.emitEvent(TYPE_A);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('Detector.ignore(emitter: obj) unhooks all EventActions from the specified emitter', (){
      detector.ignore(emitter: emitter1);
      emitter1.emitEvent(TYPE_A);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('Listening to Emitter.OMNI event type detects all events from an emitter', (){
      detector.ignore();
      detector.listen(emitter1, OMNI, detectEvent);
      emitter1.emitEvent(TYPE_A);
      emitter1.emitEvent(TYPE_A);
      emitter1.emitEvent(TYPE_B);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(2));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('A detector will throw a DuplicateEventSettingError if it attempts to listen to the same emitter/event_type combination more than once', (){
      try{
        detector.listen(emitter1, TYPE_A, (event){});
      }catch(error){
        expect(error is DuplicateEventSettingError, equals(true));
      }
    });

    test('An emitter will throw a EmitTimeQueueChangeError if an attempt is made to add or remove an EventAction during the time that event is being emitted', (){
      var detectorCopy = detector;
      emitter1.addEventAction(TYPE_A, (event){
        try{
          detectorCopy.ignore();
        }catch(error){
          expect(error is EmitTimeQueueChangeError, equals(true));
        }
      });
      emitter1.emitEvent(TYPE_A);
      Timer.run(expectAsync0((){}));
    });

  });
}