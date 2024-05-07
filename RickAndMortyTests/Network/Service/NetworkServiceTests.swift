//
//  NetworkServiceTests.swift
//  RickAndMortyTests
//
//  Created by David Alarcon on 7/5/24.
//

import XCTest
@testable import RickAndMorty

final class NetworkServiceTests: XCTestCase {

  func testNetworkServiceWhenSuccessfulResponse() async throws {
    /// Given
    let succesfullMessage = "Test Succesfull"
    MockURLProtocol.mockResponses = try NetworkServiceTests.successfullResponse(with: succesfullMessage)
    let sut = NetworkServiceTests.mockNetworkService()
    
    /// When
    let dummyTestModel: DummyTestModel = try await sut.request(from: DummyEndpoint())
    
    /// Then
    XCTAssertEqual(dummyTestModel.message, succesfullMessage)
  }
  
  func testNetworkServiceWhenFailureResponseAsInvalidURL() async {
    /// Given
    let sut = NetworkServiceTests.mockNetworkService()
    
    /// When / Then
    await XCTAssertThrowsErrorAsync(
      try await sut.request(from: DummyInvalidURLEndpoint()) as DummyTestModel,
      NetworkError.invalidURL
    )
  }
  
  func testNetworkServiceWhenFailureResponseAsInvalidResponse() async throws {
    /// Given
    let sut = NetworkServiceTests.mockNetworkService()
    let url = try XCTUnwrap(DummyEndpoint().urlRequest?.url)
    let expectedResponse = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil))
    MockURLProtocol.mockResponses = try NetworkServiceTests.failureResponse(with: expectedResponse)
    
    /// When / Then
    await XCTAssertThrowsErrorAsync(
      try await sut.request(from: DummyEndpoint()) as DummyTestModel,
      NetworkError.invalidResponse(expectedResponse)
    )
  }
  
  func testNetworkServiceWhenFailureResponseAsEmptyData() async throws {
    /// Given
    let sut = NetworkServiceTests.mockNetworkService()
    MockURLProtocol.mockResponses = try NetworkServiceTests.failureResponseEmptyData()
    
    /// When / Then
    await XCTAssertThrowsErrorAsync(
      try await sut.request(from: DummyEndpoint()) as DummyTestModel,
      NetworkError.emptyData
    )
  }
  
  func testNetworkServiceWhenWhenFailureResponseAsInvalidJSON() async throws {
    /// Given
    let succesfullMessage = "Test Failure"
    MockURLProtocol.mockResponses = try NetworkServiceTests.failureJSONResponse(with: succesfullMessage)
    let sut = NetworkServiceTests.mockNetworkService()
    
    /// When / Then
    await XCTAssertThrowsErrorAsync(
      try await sut.request(from: DummyEndpoint()) as DummyTestModel,
      NetworkError.invalidJSON(NetworkError.invalidURL)
    )
  }
}

extension NetworkServiceTests {
  
  static func mockNetworkService() -> NetworkServiceProtocol {
    URLProtocol.registerClass(MockURLProtocol.self)
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses?.insert(MockURLProtocol.self, at: .zero)
    
    return NetworkService(configuration: configuration)
  }
  
  static func successfullResponse(with message: String = "Success") throws -> [URL: (Data?, URLResponse?, Error?)] {
    guard let url = DummyEndpoint().urlRequest?.url else { throw NetworkError.invalidURL }
    
    let expectedData = DummyTestModel(message: message).json.data(using: .utf8)
    let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    return [url: (expectedData, expectedResponse, .none)]
  }
  
  static func failureResponse(with response: HTTPURLResponse) throws -> [URL: (Data?, URLResponse?, Error?)] {
    guard let url = DummyEndpoint().urlRequest?.url else { throw NetworkError.invalidURL }
    
    return [url: (.none, response, .none)]
  }
  
  static func failureResponseEmptyData() throws -> [URL: (Data?, URLResponse?, Error?)] {
    guard let url = DummyEndpoint().urlRequest?.url else { throw NetworkError.invalidURL }
    
    let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    return [url: (.none, expectedResponse, .none)]
  }
  
  static func failureJSONResponse(with message: String = "Success") throws -> [URL: (Data?, URLResponse?, Error?)] {
    guard let url = DummyEndpoint().urlRequest?.url else { throw NetworkError.invalidURL }
    
    let expectedData = DummyTestModel(message: message).invalidJson.data(using: .utf8)
    let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    return [url: (expectedData, expectedResponse, .none)]
  }
}

extension NetworkError: Equatable {
  public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case
      (.invalidURL, .invalidURL),
      (.invalidResponse, .invalidResponse),
      (.emptyData, .emptyData),
      (.invalidJSON, .invalidJSON) : return true
    default: return false
    }
  }
}

extension NetworkError: Comparable {
  public static func < (lhs: NetworkError, rhs: NetworkError) -> Bool {
    return lhs.intValue < rhs.intValue
  }
  
  private var intValue: Int {
    switch self {
    case .invalidURL: return 0
    case .invalidResponse: return 1
    case .emptyData: return 2
    case .invalidJSON: return 3
    }
  }
}
