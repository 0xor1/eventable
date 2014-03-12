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

/// Special event type which allows an [EventAction] to be called on all event types.
const String OMNI = 'omni';

/// Function signature of an [EventAction].
typedef void EventAction(Event event);