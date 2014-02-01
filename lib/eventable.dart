/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library Eventable;

import 'package:json_object/json_object.dart';
import 'dart:async';

part 'emit_time_queue_change_error.dart';
part 'duplicate_event_setting_error.dart';
part 'event.dart';
part 'event_emitter.dart';
part 'event_detector.dart';

const String OMNI = 'omni';
typedef void EventAction(Event event);