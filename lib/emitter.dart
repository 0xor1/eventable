part of Eventable;

class Emitter{


  Map<String, List<EventAction>> _actionQueues;


  void addEventAction(String type, EventAction action){
    if(_actionQueues == null){
      _actionQueues = new Map<String, List<EventAction>>();
    }
    if(_actionQueues[type] == null){
      _actionQueues[type] = new List<EventAction>();
    }
    _actionQueues[type].add(action);
  }


  void removeEventAction(String type, EventAction action){
    if(_actionQueues != null && _actionQueues[type] != null){
      _actionQueues[type].remove(action);
      if(_actionQueues[type].isEmpty){
        _actionQueues.remove(type);
      }
    }
  }


  void emitEvent(String type, [IEvent event]){
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


}