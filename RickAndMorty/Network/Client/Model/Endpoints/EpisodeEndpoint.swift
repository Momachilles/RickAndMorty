//
//  EpisodeEndpoint.swift
//  RickAndMorty
//
//  Created by David Alarcon on 2/5/24.
//

import Foundation

struct EpisodeEndpoint: RickAndMortyEndpoint {
  var urlString: String
  var path: String { "" }
  var urlRequest: URLRequest? {
    guard let url = URL(string: urlString) else { return .none }
    
    return URLRequest(url: url)
  }
}
