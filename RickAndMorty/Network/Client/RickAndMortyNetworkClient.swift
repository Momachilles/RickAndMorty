//
//  RickAndMortyNetworkClient.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import SwiftUI

protocol RickAndMortyAPI {
  func characters() async throws -> Characters
}

@Observable
class RickAndMortyNetworkClient {
  private let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
}

extension RickAndMortyNetworkClient: RickAndMortyAPI {
  func characters() async throws -> Characters {
    try await networkService.request(from: CharactersEndpoint())
  }
}
