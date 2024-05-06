//
//  RickAndMortyEndpoint.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import Foundation

protocol RickAndMortyEndpoint: Endpoint, URLRequestable {
  var urlString: String? { get set }
}

extension RickAndMortyEndpoint {
  var scheme: String { "https" }
  var host: String { "rickandmortyapi.com" }
  var baseURLString: String { "/api" }
  var queryParameters: [String : String]? { .none }
  var method: Method { .get }
  var urlString: String? { .none }
  var path: String { "" }
}

extension RickAndMortyEndpoint {
  var urlRequest: URLRequest? {
    if let urlString = urlString, let url = URL(string: urlString) { return URLRequest(url: url) }
    
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
