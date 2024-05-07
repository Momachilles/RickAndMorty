//
//  MockTestModel.swift
//  OpenWeatherMapTests
//
//  Created by David Alarcon on 18/4/24.
//

import Foundation

struct DummyTestModel: Codable {
  var message: String
}

extension DummyTestModel {
  var json: String { "{\"message\": \"\(message)\"}"}
  var invalidJson: String { "{\"invalidMessage\": \"\(message)\"}" }
}
