/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Eventable;

/**
 * Thrown when [detector] attempts to add [newAction] to [emitter]s action queue
 * of [type] and an [existingAction] is already assigned.
 */
class DuplicateEventSettingError extends Error{

  final String message;
  final String type;
  final EventEmitter emitter;
  final EventDetector detector;
  final EventAction existingAction;
  final EventAction newAction;

  DuplicateEventSettingError(EventDetector detector, EventEmitter emitter, String type, EventAction existingAction, EventAction newAction):
    message = 'The detector is already listening for the "$type" event from the given emitter',
    type = type,
    emitter = emitter,
    detector = detector,
    existingAction = existingAction,
    newAction = newAction
    {
    }

}