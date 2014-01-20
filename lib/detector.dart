part of Eventable;


class Detector{


  Map<Emitter, Map<String, EventAction>> _typeIndexes;
  Map<String, Map<Emitter, EventAction>> _emitterIndexes;


  void listen(Emitter emitter, String type, EventAction action){
    _initialiseIndexes(emitter, type);
    if(_typeIndexes[emitter][type] != null){
      throw new DuplicateEventSettingError(this, emitter, type);
    }else{
      _typeIndexes[emitter][type] = _emitterIndexes[type][emitter] = action;
      emitter.addEventAction(type, action);
    }
  }


  void ignore({Emitter emitter, String type}){
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


  void _initialiseIndexes(emitter, type){
    if(_typeIndexes == null){
      _typeIndexes = new Map<Emitter, Map<String, EventAction>>();
    }
    if(_typeIndexes[emitter] == null){
      _typeIndexes[emitter] = new Map<String, EventAction>();
    }
    if(_emitterIndexes == null){
      _emitterIndexes = new Map<String, Map<Emitter, EventAction>>();
    }
    if(_emitterIndexes[type] == null){
      _emitterIndexes[type] = new Map<Emitter, EventAction>();
    }
  }


  void _removeActionFromSpecificEmitterForSpecificEvent(Emitter emitter, String type){
    if(_typeIndexes != null && _typeIndexes[emitter] != null && _typeIndexes[emitter][type] != null){
      EventAction action = _typeIndexes[emitter].remove(type);
      _emitterIndexes[type].remove(emitter);
      emitter.removeEventAction(type, action);
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


  void _removeActionsFromSpecificEmitterForAllEvents(Emitter emitter){
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