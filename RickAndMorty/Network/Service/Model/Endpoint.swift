//
//  Endpoint.swift
//  OpenWeatherMap
//
//  Created by David Alarcon on 15/4/24.
//

import Foundation

enum Method: String {
  case get = "GET"
  
  var string: String { rawValue }
}

protocol Endpoint {
  var scheme: String { get }
  var host: String { get }
  var baseURLString: String { get }
  var path: String { get }
  var method: Method { get }
  var queryParameters: [String: String]? { get }
}

protocol URLRequestable {
  var urlRequest: URLRequest? { get }
}
