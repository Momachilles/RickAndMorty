//
//  MockURLProtocol.swift
//  OpenWeatherMapTests
//
//  Created by David Alarcon on 18/4/24.
//

import Foundation

import Foundation

class MockURLProtocol: URLProtocol {
  // Use a dictionary to map request URLs to their mock responses
  static var mockResponses: [URL: (Data?, URLResponse?, Error?)] = [:]

  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {
    if let url = request.url,
       let (data, response, error) = MockURLProtocol.mockResponses[url] {
      if let error = error {
        client?.urlProtocol(self, didFailWithError: error)
      } else {
        if let response = response {
          client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = data {
          client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
      }
    } else {
      client?.urlProtocol(self, didFailWithError: URLError(.unknown))
    }
  }

  override func stopLoading() { }
}
