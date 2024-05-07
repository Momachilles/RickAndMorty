//
//  XCTAssertThrowsErrorAsync.swift
//  RickAndMortyTests
//
//  Created by David Alarcon on 7/5/24.
//

import Foundation
import XCTest

/// Source:  [Testing async/await exceptions](https://arturgruchala.com/testing-async-await-exceptions/)
///
/// Example usage:
/// ```
/// await XCTAssertThrowsErrorAsync(
///   try await myThrowingFunc(),
///   Error.myExpectedError
/// )
/// ```
/// - Parameters:
///   - expression: An asynchronous expression that can throw an error.
///   - message: An optional description of a failure.
///   - file: The file where the failure occurs.
///     The default is the filename of the test case where you call this function.
///   - line: The line number where the failure occurs.
///     The default is the line number where you call this function.
func XCTAssertThrowsErrorAsync<T, R>(
  _ expression: @autoclosure () async throws -> T,
  _ errorThrown: @autoclosure () -> R,
  _ message: @autoclosure () -> String = "This method should fail",
  file: StaticString = #filePath,
  line: UInt = #line
) async where R: Comparable, R: Error  {
  do {
    let _ = try await expression()
    XCTFail(message(), file: file, line: line)
  } catch {
    XCTAssertEqual(error as? R, errorThrown())
  }
}
