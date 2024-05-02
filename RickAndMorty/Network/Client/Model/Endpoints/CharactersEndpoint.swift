//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import Foundation

struct CharactersEndpoint: RickAndMortyEndpoint {
  var name: String?
  var path: String { "/character" }
  var queryParameters: [String : String]? {
    var parameters: [String: String] = [:]
    
    if let name = name, !name.isEmpty { parameters["name"] = name }
    
    return parameters
  }
}
