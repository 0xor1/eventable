/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

/**
 * Thrown when an [EventAction] attempts to add or remove [EventAction](s) from
 * the action queue currently being called.
 */
class EmitTimeQueueChangeError extends Error{

  final String message;
  final String type;
  final EventEmitter emitter;
  final EventAction action;

  EmitTimeQueueChangeError(EventEmitter emitter, String type, EventAction action):
    message = 'The emitter is currently emitting an event of type "$type", a call to add/removeEventAction at emit time, of that event type, is an error.',
    emitter = emitter,
    type = type,
    action = action
    {
    }

}