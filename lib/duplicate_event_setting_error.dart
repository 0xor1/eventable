part of Eventable;


class DuplicateEventSettingError extends Error{


  final String message;
  final EventEmitter emitter;
  final EventDetector detector;


  DuplicateEventSettingError(EventDetector detector, EventEmitter emitter, String type):
    message = 'The detector is already listening for the "$type" event from the given emitter',
    emitter = emitter,
    detector = detector
    {
    }


}