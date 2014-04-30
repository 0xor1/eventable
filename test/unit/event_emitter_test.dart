/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableTest;

void runEventEmitterTests(){

  group('EventEmitter', (){

    test('EventActions are called asynchronously.', (){
      emitter1.emitEvent(new TypeA());
      expect(lastDetectedEvent, equals(null));
      expectAsyncWithReadyCheckAndTimeout(() => lastDetectedEvent != null, () => expect(lastDetectedEvent.originalEmitter, equals(emitter1)));
    });

    test('listening to Omni event type detects all events from an emitter.', (){
      detector.ignoreAllEvents();
      detector.listen(emitter1, Omni, detectEvent);
      emitter1.emitEvent(new TypeA());
      emitter1.emitEvent(new TypeA());
      emitter1.emitEvent(new TypeB());
      emitter2.emitEvent(new TypeB());
      expectAsyncWithReadyCheckAndTimeout(
        () => eventADetectedCount == 2 && eventBDetectedCount == 1,
        (){
          expect(eventADetectedCount, equals(2));
          expect(eventBDetectedCount, equals(1)); 
        });
    });

    test('throws an EmitTimeQueueChangeError if an attempt is made to add or remove an EventAction during the time that event is being emitted.', (){
      var detector = new EventDetector();
      var error;
      detector.listen(emitter1, TypeA, (event){
          detector.ignoreAllEvents();
      });
      emitter1.emitEvent(new TypeA()).catchError((e){
        error = e;
      });
      expectAsyncWithReadyCheckAndTimeout(
        () => error != null,
        (){
          expect(error is EmitTimeQueueChangeError, equals(true));
        });
    });

  });

}