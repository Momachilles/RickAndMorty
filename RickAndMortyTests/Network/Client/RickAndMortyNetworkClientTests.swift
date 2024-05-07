//
//  RickAndMortyNetworkClientTests.swift
//  RickAndMortyTests
//
//  Created by David Alarcon on 7/5/24.
//

import XCTest
@testable import RickAndMorty

final class RickAndMortyNetworkClientTests: XCTestCase {

  func testRickAndMortyNetworkClientCharacters() async throws {
    /// Given
    let networkService = MockNetworkService()
    let expectedResult = try DummyCharactersLoader.loadCharacters()
    networkService.requestResult = expectedResult
    let sut = RickAndMortyNetworkClient(networkService: networkService)
    
    /// When
    let result = try await sut.characters(by: "")
      
    /// Then
    XCTAssertEqual(result, expectedResult)
  }
  
  func testRickAndMortyNetworkClientEpisodes() async throws {
    /// Given
    let networkService = MockNetworkService()
    let expectedResult = try DummyEpisodeLoader.loadEpisode()
    networkService.requestResult = expectedResult
    let sut = RickAndMortyNetworkClient(networkService: networkService)
    
    /// When
    let result = try await sut.episode(from: "https://rickandmortyapi.com/api/episode/1")
    
    /// Then
    XCTAssertEqual(result, expectedResult)
  }
}

extension Characters: Equatable {
  public static func == (lhs: Characters, rhs: Characters) -> Bool {
    lhs.info.next == rhs.info.next
  }
}

extension Episode: Equatable {
  public static func == (lhs: Episode, rhs: Episode) -> Bool {
    lhs.id == rhs.id
  }
}
