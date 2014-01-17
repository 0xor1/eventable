part of Eventable;

class DuplicateEventSettingError extends Error{

  final String message;
  final Eventable emitter;
  final Eventable detector;

  DuplicateEventSettingError(Eventable detector, Eventable emitter, String type):
   message = 'The detector is already listening for the "$type" event from the given emitter',
   emitter = emitter,
   detector = detector
   {
   }

}