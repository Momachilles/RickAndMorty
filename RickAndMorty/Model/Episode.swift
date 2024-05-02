//
//  Episode.swift
//  RickAndMorty
//
//  Created by David Alarcon on 2/5/24.
//

import Foundation

struct Episode: Decodable {
  let id: Int
  let name: String
  let airDate: String
  let episode: String
  let characters: [String]
  let url: String
  let created: String
  
  enum CodingKeys: String, CodingKey {
    case id, name, episode, characters, url, created
    case airDate = "air_date"
  }
}
