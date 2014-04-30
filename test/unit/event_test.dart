/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableTest;

void runEventTests(){

  group('Event', (){

    test('contains the original emitter object by default.', (){
      emitter1.emitEvent(new TypeA());
      expectAsyncWithReadyCheckAndTimeout(() => lastDetectedEvent != null, () => expect(lastDetectedEvent.originalEmitter, equals(emitter1)));
    });

    test('contains the current emitter object by default.', (){
      emitter1.emitEvent(new TypeA());
      expectAsyncWithReadyCheckAndTimeout(() => lastDetectedEvent != null, () => expect(lastDetectedEvent.currentEmitter, equals(relay)));
    });

    test('is extendable', (){
      emitter1.emitEvent(new TypeA()..aDynamicProperty = 1);
      expectAsyncWithReadyCheckAndTimeout(() => lastDetectedEvent != null, () => expect(lastDetectedEvent.aDynamicProperty, equals(1)));
    });

  });

}