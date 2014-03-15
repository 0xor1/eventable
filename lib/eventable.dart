/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

/**
 * Mixins to make any object into an [EventEmitter] or [EventDetector] and create
 * custom [Event] objects.
 */
library Eventable;

import 'package:transmittable/transmittable.dart';
import 'dart:async';

part 'emit_time_queue_change_error.dart';
part 'duplicate_event_setting_error.dart';
part 'event.dart';
part 'event_emitter.dart';
part 'event_detector.dart';

/**
 * Special [Event] type used for listening to all events from an [EventEmitter]
 * with a single [EventAction].
 */
class Omni extends Event{}

/// Function signature of an [EventAction].
typedef void EventAction(Event event);