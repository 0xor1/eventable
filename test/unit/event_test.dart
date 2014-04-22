/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableTest;

void runEventTests(){

  group('Event', (){

    setUp(setUpTestObjects);

    tearDown(tearDownTestObjects);

    test('contains the emitter object by default.', (){
      emitter1.emitEvent(new TypeA());
      Timer.run(expectAsync((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

  });

}