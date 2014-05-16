/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of eventable.test;

void runEventDetectorTests(){

  group('EventDetector', (){

    test('.ignoreAllEvents() unhooks all EventActions.', (){
      detector.ignoreAllEvents();
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      Timer.run(expectAsync((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(0));
      }));
    });

    test('calling ignore methods doesn\'t throw errors when no events are currently being listened for.', (){
      var detector = new EventDetector();
      var emitter = new EventEmitter();
      detector.ignoreAllEvents();
      detector.ignoreAllEventsFrom(emitter);
      detector.ignoreAllEventsOfType(Object);
      expect(true, equals(true));
    });

    test('.ignoreAllEventsOfType(eventType) unhooks all EventActions of the specified type.', (){
      detector.ignoreAllEventsOfType(TypeA);
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      Timer.run(expectAsync((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('.ignoreAllEventsFrom(emitter) unhooks all EventActions from the specified emitter.', (){
      detector.ignoreAllEventsFrom(emitter1);
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      Timer.run(expectAsync((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('throws a DuplicateEventSettingError if it attempts to listen to the same emitter/event_type combination more than once.', (){
      expect(() => detector.listen(emitter1, TypeA, (event){}), throwsA(new isInstanceOf<DuplicateEventSettingError>()));
    });

  });

}