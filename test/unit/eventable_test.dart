library EventableTest;

import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:eventable/eventable.dart';

void main(){

  group('', (){

    const String TYPE_A = 'type_a';
    const String TYPE_B = 'type_b';

    EventEmitter emitter1;
    EventEmitter emitter2;
    EventDetector detector;

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
      emitter1 = new EventEmitter();
      emitter2 = new EventEmitter();
      detector = new EventDetector();

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

    test('EventDetector.ignore() unhooks all EventActions', (){
      detector.ignoreAllEvents();
      emitter1.emitEvent(TYPE_A);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(0));
      }));
    });

    test('EventDetector.ignore(type:eventType) unhooks all EventActions of the specified type', (){
      detector.ignoreAllEventsOfType(TYPE_A);
      emitter1.emitEvent(TYPE_A);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('EventDetector.ignore(emitter: obj) unhooks all EventActions from the specified emitter', (){
      detector.ignoreAllEventsFrom(emitter1);
      emitter1.emitEvent(TYPE_A);
      emitter2.emitEvent(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('Listening to OMNI event type detects all events from an emitter', (){
      detector.ignoreAllEvents();
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
      var error;
      emitter1.addEventAction(TYPE_A, (event){
          detectorCopy.ignoreAllEvents();
      });
      emitter1.emitEvent(TYPE_A).catchError((e){
        error = e;
      });
      Timer.run(expectAsync0((){
        expect(error is EmitTimeQueueChangeError, equals(true));
      }));
    });

  });
}