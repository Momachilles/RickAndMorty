//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse(URLResponse?)
  case emptyData
  case invalidJSON(Error)
}

protocol NetworkServiceProtocol {
  func request<T: Decodable>(from requestConvertible: URLRequestable) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
  private let session: URLSession

  init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
    self.session = URLSession(configuration: configuration)
  }

  func request<T: Decodable>(from requestConvertible: any URLRequestable) async throws -> T {
    guard let urlRequest = requestConvertible.urlRequest else { throw NetworkError.invalidURL }

    let (data, response) = try await session.data(for: urlRequest)

    guard
      let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200
    else { throw NetworkError.invalidResponse(response) }

    guard !data.isEmpty else { throw NetworkError.emptyData }

    do { return try JSONDecoder().decode(T.self, from: data) }
    catch { throw NetworkError.invalidJSON(error) }
  }
}
