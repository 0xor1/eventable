/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

/**
 * A mixin class to enable any object to emit custom events.
 */
class EventEmitter{

  Map<String, List<EventAction>> _actionQueues;
  /// Describes whether the object is currently emitting an event.
  bool get isEmitting => _emittingType != null;
  String _emittingType;
  /// Specifies which event type is currently being emitted by the object.
  String get emittingType => _emittingType;

  /**
   * Adds the [action] to the action queue of [type].
   */
  void addEventAction(String type, EventAction action){
    if(_emittingType == type){
      _emittingType = null;
      throw new EmitTimeQueueChangeError(this, type, action);
    }
    if(_actionQueues == null){
      _actionQueues = new Map<String, List<EventAction>>();
    }
    if(_actionQueues[type] == null){
      _actionQueues[type] = new List<EventAction>();
    }
    _actionQueues[type].add(action);
  }

  /**
   * Removes the [action] from the action queue of [type].
   */
  void removeEventAction(String type, EventAction action){
    if(_emittingType == type){
      _emittingType = null;
      throw new EmitTimeQueueChangeError(this, type, action);
    }
    if(_actionQueues != null && _actionQueues[type] != null){
      _actionQueues[type].remove(action);
      if(_actionQueues[type].isEmpty){
        _actionQueues.remove(type);
      }
    }
  }

  /**
   * Calls all the actions in the queue of [type] with the optional [event] asynchronously,
   * returning a [Future] that completes when all of the actions have been called.
   */
  Future emitEvent(String type, [IEvent event]){
    if(event == null){
      event = new Event();
    }
    event.emitter = this;
    event.type = type;

    //make eventQueues execute async so only one event queue is ever executing at a time.
    return new Future.delayed(new Duration(), (){
      _emittingType = type;
      if(_actionQueues != null && _actionQueues[type] != null){
        _actionQueues[type].forEach((EventAction action){ action(event); });
      }

      if(_actionQueues != null && _actionQueues[OMNI] != null){
        _actionQueues[OMNI].forEach((EventAction action){ action(event); });
      }
      _emittingType = null;
    });
  }

}