/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableTest;

void runEventTests(){

  group('Event', (){

    setUp(setUpTestObjects);

    tearDown(tearDownTestObjects);

    test('contains the emitter object by default.', (){
      emitter1.emitEvent(TYPE_A);
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.emitter, equals(emitter1));
      }));
    });

    test('contains the event type string by default.', (){
      emitter1.emitEvent(TYPE_A);
      Timer.run(expectAsync0((){
        expect(lastDetectedEvent.type, equals(TYPE_A));
      }));
    });

    test('is extendable, meaning new properties can be added at anytime.', (){
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

  });

}