//
//  RickAndMortyEndpoint.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import Foundation

protocol RickAndMortyEndpoint: Endpoint, URLRequestable {}

extension RickAndMortyEndpoint {
  var scheme: String { "https" }
  var host: String { "rickandmortyapi.com" }
  var baseURLString: String { "/api" }
  var queryParameters: [String : String]? { .none }
  var method: Method { .get }
}

extension RickAndMortyEndpoint {
  var urlRequest: URLRequest? {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = baseURLString + path
    components.queryItems = queryParameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    guard let url = components.url else { return .none }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.string
    
    return request
  }
}
