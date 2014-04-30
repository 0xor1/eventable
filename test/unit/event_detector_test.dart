/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableTest;

void runEventDetectorTests(){

  group('EventDetector', (){

    test('.ignoreAllEvents() unhooks all EventActions.', (){
      detector.ignoreAllEvents();
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      expectAsyncWithReadyCheckAndTimeout(
        () => lastRelayedEvent is TypeB, 
        (){
          expect(eventADetectedCount, equals(0));
          expect(eventBDetectedCount, equals(0));
        });
    });

    test('calling ignore methods doesn\'t throw errors when no events are currently being listened for.', (){
      var detector = new EventDetector();
      detector.ignoreAllEvents();
      detector.ignoreAllEventsFrom(emitter1);
      detector.ignoreAllEventsOfType(Object);
      expect(true, equals(true));
    });

    test('.ignoreAllEventsOfType(eventType) unhooks all EventActions of the specified type.', (){
      detector.ignoreAllEventsOfType(TypeA);
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      expectAsyncWithReadyCheckAndTimeout(
        () => eventBDetectedCount == 1, 
        (){
          expect(eventADetectedCount, equals(0));
          expect(eventBDetectedCount, equals(1));
        });
    });

    test('.ignoreAllEventsFrom(emitter) unhooks all EventActions from the specified emitter.', (){
      var lastDetectedEvent;
      detector.listen(emitter2, TypeB, (event){lastDetectedEvent = event;});
      detector.ignoreAllEventsFrom(relay);
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      expectAsyncWithReadyCheckAndTimeout(
        () => lastDetectedEvent != null, 
        (){
          expect(eventADetectedCount, equals(0));
          expect(eventBDetectedCount, equals(0));
          expect(lastDetectedEvent.originalEmitter, equals(emitter2));
        });
    });

    test('throws a DuplicateEventSettingError if it attempts to listen to the same emitter/event_type combination more than once.', (){
      try{
        detector.listen(emitter1, TypeA, (event){});
      }catch(error){
        expect(error is DuplicateEventSettingError, equals(true));
      }
    });

  });

}