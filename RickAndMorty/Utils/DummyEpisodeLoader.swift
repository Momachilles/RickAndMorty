//
//  DummyEpisodeLoader.swift
//  RickAndMorty
//
//  Created by David Alarcon on 7/5/24.
//

import Foundation

class DummyEpisodeLoader {
  static func loadEpisode() throws -> Episode {
    guard let url = Bundle.main.url(forResource: "Episode", withExtension: "json") else {
      throw NSError(domain: "DummyEpisodeLoader", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
    }
    
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return try decoder.decode(Episode.self, from: data)
  }
}
