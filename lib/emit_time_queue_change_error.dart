part of Eventable;


class EmitTimeQueueChangeError extends Error{


  final String message;
  final String type;
  final Emitter emitter;
  final EventAction action;


  EmitTimeQueueChangeError(Emitter emitter, String type, EventAction action):
    message = 'The emitter is currently emitting an event of type "$type", a call to add/removeEventAction at emit time, of that event type, is an error.',
    emitter = emitter,
    type = type,
    action = action
    {
    }


}