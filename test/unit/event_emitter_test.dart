/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of eventable.test;

void runEventEmitterTests(){

  group('EventEmitter', (){

    test('EventActions are called asynchronously.', (){
      emitter1.emitEvent(new TypeA());
      expect(lastDetectedEvent, equals(null));
      Timer.run(expectAsync((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('listening to Omni event type detects all events from an emitter.', (){
      detector.ignoreAllEvents();
      detector.listen(emitter1, Omni, detectEvent);
      emitter1.emitEvent(new TypeA());
      emitter1.emitEvent(new TypeA());
      emitter1.emitEvent(new TypeB());
      emitter2.emitEvent(new TypeB());
      Timer.run(expectAsync((){
        expect(eventADetectedCount, equals(2));
        expect(eventBDetectedCount, equals(1));
      }));
    });

    test('throws an EmitTimeQueueChangeError if an attempt is made to add or remove an EventAction during the time that event is being emitted.', (){
      var detectorCopy = detector;
      var error;
      emitter1.addEventAction(TypeA, (event){
          detectorCopy.ignoreAllEvents();
      });
      expect(emitter1.emitEvent(new TypeA()), throwsA(new isInstanceOf<EmitTimeQueueChangeError>()));
    });

    test('emitEvent returns a Future which completes with the emitted event.', (){
      var setInFuture;
      emitter1.emitEvent(new TypeA()).then((event){ setInFuture = event; });
      Timer.run(expectAsync((){
        Timer.run(expectAsync((){
          expect(setInFuture, equals(lastDetectedEvent));
        }));
      }));
    });

  });

}