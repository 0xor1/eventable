/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of eventable.test;

void runEventTests(){

  group('Event', (){

    test('contains the emitter object by default.', (){
      emitter1.emitEvent(new TypeA());
      Timer.run(expectAsync((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('contains the event data.', (){
      var data = new TypeA();
      emitter1.emitEvent(data);
      Timer.run(expectAsync((){
        expect(lastDetectedEvent.data, equals(data));
      }));
    });

    test('contains the finished future which completes with the event.', (){
      var data = new TypeA();
      emitter1.emitEvent(data);
      Timer.run(expectAsync((){
        var setInFuture;
        lastDetectedEvent.finished.then((event){ setInFuture = event; });
        Timer.run(expectAsync((){
          expect(setInFuture.data, equals(data));
        }));
      }));
    });

    test('event.data is readonly.', (){
      emitter1.emitEvent(new TypeA());
      Timer.run(expectAsync((){
        expect(() => lastDetectedEvent.data = null, throwsA(new isInstanceOf<NoSuchMethodError>()));
      }));
    });

    test('event.emitter is readonly.', (){
      emitter1.emitEvent(new TypeA());
      Timer.run(expectAsync((){
        expect(() => lastDetectedEvent.emitter = null, throwsA(new isInstanceOf<NoSuchMethodError>()));
      }));
    });

    test('event.finished is getter only.', (){
      emitter1.emitEvent(new TypeA());
      Timer.run(expectAsync((){
        expect(() => lastDetectedEvent.finished = null, throwsA(new isInstanceOf<NoSuchMethodError>()));
      }));
    });

  });

}