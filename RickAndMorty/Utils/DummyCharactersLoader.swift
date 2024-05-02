//
//  DummyCharactersLoader.swift
//  RickAndMorty
//
//  Created by David Alarcon on 2/5/24.
//

import Foundation

class DummyCharactersLoader {
  static func loadCharacters() throws -> Characters {
    guard let url = Bundle.main.url(forResource: "AllCharacters", withExtension: "json") else {
      throw NSError(domain: "DummyCharactersLoader", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
    }
    
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return try decoder.decode(Characters.self, from: data)
  }
}
