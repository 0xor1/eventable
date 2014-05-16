/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of eventable;

/**
 * All event data comes inside an [Event] object.
 */
class Event{

  /// The emitting object
  final EventEmitter emitter;
  /// The event data
  final dynamic data;
  /// completes when the event has finished propogating
  Future get finished => _finished;
  Future _finished;

  Event._internal(this.emitter, this.data);
}