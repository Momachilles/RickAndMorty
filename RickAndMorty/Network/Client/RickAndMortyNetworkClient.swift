//
//  RickAndMortyNetworkClient.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import SwiftUI

protocol RickAndMortyAPI {
  func characters(by name: String,  next urlString: String?) async throws -> Characters
  func episode(from urlString: String) async throws -> Episode
}

@Observable
class RickAndMortyNetworkClient {
  private let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
}

extension RickAndMortyNetworkClient: RickAndMortyAPI {
  func characters(by name: String, next urlString: String? = .none) async throws -> Characters {
    try await networkService.request(from: CharactersEndpoint(name: name, urlString: urlString))
  }
  
  func episode(from urlString: String) async throws -> Episode {
    try await networkService.request(from: EpisodeEndpoint(urlString: urlString))
  }
}
