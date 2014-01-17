library Eventable;


import 'package:json_object/json_object.dart';
import 'dart:async';


part 'duplicate_event_setting_error.dart';
part 'event.dart';


typedef void EventAction(Event event);


class Eventable{


  static const String OMNI = 'omni';


  Map<Eventable, Map<String, EventAction>> _typeIndexes;
  Map<String, Map<Eventable, EventAction>> _emitterIndexes;
  Map<String, List<EventAction>> _actionQueues;


  void listen(Eventable emitter, String type, EventAction action){
    _initialiseIndexes(emitter, type);
    if(_typeIndexes[emitter][type] != null){
      throw new DuplicateEventSettingError(this, emitter, type);
    }else{
      _typeIndexes[emitter][type] = _emitterIndexes[type][emitter] = action;
      emitter._initialiseEventActionQueue(type).add(action);
    }
  }


  void ignore({Eventable emitter, String type}){
    if(emitter != null && type != null){
      _removeActionFromSpecificEmitterForSpecificEvent(emitter, type);
    }else if(emitter == null && type != null){
      _removeActionsFromAllEmittersForSpecificEvent(type);
    }else if(emitter != null && type == null){
      _removeActionsFromSpecificEmitterForAllEvents(emitter);
    }else{
      _removeActionsFromAllEmittersForAllEvents();
    }
  }


  void emit(String type, [IEvent event]){
    if(event == null){
      event = new Event();
    }
    event.emitter = this;
    event.type = type;
    //make eventQueues execute async so only one event queue is ever executing at a time.
    Timer.run((){
      if(_actionQueues != null && _actionQueues[type] != null){
        _actionQueues[type].forEach((EventAction action){ action(event); });
      }

      if(_actionQueues != null && _actionQueues[OMNI] != null){
        _actionQueues[OMNI].forEach((EventAction action){ action(event); });
      }
    });
  }


  List<EventAction> _initialiseEventActionQueue(String type){
    if(_actionQueues == null){
      _actionQueues = new Map<String, List<EventAction>>();
    }
    if(_actionQueues[type] == null){
      _actionQueues[type] = new List<EventAction>();
    }
    return _actionQueues[type];
  }


  void _initialiseIndexes(emitter, type){
    if(_typeIndexes == null){
      _typeIndexes = new Map<Eventable, Map<String, EventAction>>();
    }
    if(_typeIndexes[emitter] == null){
      _typeIndexes[emitter] = new Map<String, EventAction>();
    }
    if(_emitterIndexes == null){
      _emitterIndexes = new Map<String, Map<Eventable, EventAction>>();
    }
    if(_emitterIndexes[type] == null){
      _emitterIndexes[type] = new Map<Eventable, EventAction>();
    }
  }

  void _removeActionFromSpecificEmitterForSpecificEvent(Eventable emitter, String type){
    if(_typeIndexes != null && _typeIndexes[emitter] != null && _typeIndexes[emitter][type] != null){
      EventAction action = _typeIndexes[emitter].remove(type);
      _emitterIndexes[type].remove(emitter);
      emitter._actionQueues[type].remove(action);
      if(_typeIndexes[emitter].isEmpty){
        _typeIndexes.remove(emitter);
      }
      if(_emitterIndexes[type].isEmpty){
        _emitterIndexes.remove(type);
      }
    }
  }

  void _removeActionsFromAllEmittersForSpecificEvent(String type){
    if(_emitterIndexes != null && _emitterIndexes[type] != null){
      var emitterIndex = _emitterIndexes[type];
      while(emitterIndex.isNotEmpty){
        _removeActionFromSpecificEmitterForSpecificEvent(emitterIndex.keys.first, type);
      }
    }
  }

  void _removeActionsFromSpecificEmitterForAllEvents(Eventable emitter){
    if(_typeIndexes != null && _typeIndexes[emitter] != null){
      var typeIndex = _typeIndexes[emitter];
      while(typeIndex.isNotEmpty){
        _removeActionFromSpecificEmitterForSpecificEvent(emitter, typeIndex.keys.first);
      }
    }
  }

  void _removeActionsFromAllEmittersForAllEvents(){
    while(_typeIndexes.isNotEmpty){
      _removeActionsFromSpecificEmitterForAllEvents(_typeIndexes.keys.first);
    }
  }

}