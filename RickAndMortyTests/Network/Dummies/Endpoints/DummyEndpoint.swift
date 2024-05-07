//
//  DummyEndpoint.swift
//  OpenWeatherMapTests
//
//  Created by David Alarcon on 18/4/24.
//

import Foundation
@testable import OpenWeatherMap

struct DummyEndpoint: OpenWeatherMapEndpoint {
  var host: String { "test.com" }
  var baseURLString: String { "/this/is/a" }
  var path: String { "/test" }
}
