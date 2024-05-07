//
//  MockNetworkService.swift
//  OpenWeatherMapTests
//
//  Created by David Alarcon on 18/4/24.
//

import Foundation
@testable import RickAndMorty

class MockNetworkService: NetworkServiceProtocol {

  var requestResult: Decodable?

  func request<T: Decodable>(from requestConvertible: URLRequestable) async throws -> T {
    guard let result = requestResult as? T else { throw NetworkError.invalidResponse(.none) }
      
    return result
  }
}
