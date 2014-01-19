library EventableTest;

import 'package:unittest/unittest.dart';
import 'dart:async';
import 'package:eventable/eventable.dart';

void main(){

  group('', (){

    const String TYPE_A = 'type_a';
    const String TYPE_B = 'type_b';

    Eventable emitter1;
    Eventable emitter2;
    Eventable detector;

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
      emitter1 = new Eventable();
      emitter2 = new Eventable();
      detector = new Eventable();

      detector.listen(emitter1, TYPE_A, detectEvent);
      detector.listen(emitter2, TYPE_B, detectEvent);
    });

    tearDown((){
      emitter1 = emitter2 = detector = lastDetectedEvent = null;
      eventADetectedCount = eventBDetectedCount = 0;
    });

    test('EventActions are called asynchronously', (){
      emitter1.emit(TYPE_A);
      expect(lastDetectedEvent, equals(null));
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('Events contain the emitter object', (){
      emitter1.emit(TYPE_A);
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('Events contain the event type string', (){
      emitter1.emit(TYPE_A);
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.type, equals(TYPE_A));
      }));
    });

    test('Events are extendable, meaning new properties can be added to them at anytime', (){
      emitter1.emit(
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
      emitter1.emit(TYPE_A);
      emitter2.emit(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(0));
      }));
    });

    test('Detector.ignore(type:eventType) unhooks all EventActions of the specified type', (){
      detector.ignore(type: TYPE_A);
      emitter1.emit(TYPE_A);
      emitter2.emit(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('Detector.ignore(emitter: obj) unhooks all EventActions from the specified emitter', (){
      detector.ignore(emitter: emitter1);
      emitter1.emit(TYPE_A);
      emitter2.emit(TYPE_B);
      Timer.run(expectAsync0((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('Listening to Eventable.OMNI event type detects all events from an emitter', (){
      detector.ignore();
      detector.listen(emitter1, Eventable.OMNI, detectEvent);
      emitter1.emit(TYPE_A);
      emitter1.emit(TYPE_A);
      emitter1.emit(TYPE_B);
      emitter2.emit(TYPE_B);
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

  });
}