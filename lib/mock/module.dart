library angular.mock;

import 'dart:async' as dart_async;
import 'dart:convert' show JSON;
import 'dart:html';
import 'dart:mirrors' as mirror;
import '../angular.dart';
import '../utils.dart' as utils;
import 'package:js/js.dart' as js;
import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';
import 'package:unittest/mock.dart';

part 'debug.dart';
part 'exception_handler.dart';
part 'http_backend.dart';
part 'log.dart';
part 'probe.dart';
part 'test_bed.dart';
part 'zone.dart';
part 'mock_window.dart';
part 'test_injection.dart';

/**
 * Use in addition to [AngularModule] in your tests.
 *
 * [AngularMockModule] provides:
 *
 *   - [TestBed]
 *   - [Probe]
 *   - [MockHttpBackend] instead of [HttpBackend]
 *   - [Logger]
 *   - [RethrowExceptionHandler] instead of [ExceptionHandler]
 *   - [NgZone] which displays errors to console;
 */
class AngularMockModule extends Module {
  AngularMockModule() {
    type(ExceptionHandler, implementedBy: RethrowExceptionHandler);
    type(TestBed);
    type(Probe);
    type(Logger);
    type(MockHttpBackend);
    factory(HttpBackend, (Injector i) => i.get(MockHttpBackend));
    factory(NgZone, (_) {
      NgZone zone = new NgZone();
      zone.onError = (dynamic e, dynamic s, LongStackTrace ls) => dump('EXCEPTION: $e\n$s\n$ls');
      return zone;
    });
    type(Window, implementedBy: MockWindow);
  }
}
