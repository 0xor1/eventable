part of Eventable;


class DuplicateEventSettingError extends Error{


  final String message;
  final Emitter emitter;
  final Detector detector;


  DuplicateEventSettingError(Detector detector, Emitter emitter, String type):
    message = 'The detector is already listening for the "$type" event from the given emitter',
    emitter = emitter,
    detector = detector
    {
    }


}