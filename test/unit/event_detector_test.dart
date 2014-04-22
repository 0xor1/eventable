/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableTest;

void runEventDetectorTests(){

  group('EventDetector', (){

    setUp(setUpTestObjects);

    tearDown(tearDownTestObjects);

    test('.ignoreAllEvents() unhooks all EventActions.', (){
      detector.ignoreAllEvents();
      emitter1.emitEvent(new TypeA());
      emitter2.emitEvent(new TypeB());
      Timer.run(expectAsync((){
        expect(eventADetectedCount, equals(0));
        expect(eventBDetectedCount, equals(0));
      }));
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
      try{
        detector.listen(emitter1, TypeA, (event){});
      }catch(error){
        expect(error is DuplicateEventSettingError, equals(true));
      }
    });

  });

}