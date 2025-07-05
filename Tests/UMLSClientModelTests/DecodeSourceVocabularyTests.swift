// DecodeSourceVocabularyTests.swift

import XCTest

@testable import UMLSClientModel

// MARK: - DecodeUMLSLanguageNameTests

final class DecodeUMLSLanguageNameTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSLanguageName

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func testWithValidJSON() throws {
    let sets = zip(UMLSLanguageName.allCases, try data())
    for (value, data) in sets {
      let result = try jsonDecoder.decode(UMLSLanguageName.self, from: data)
      XCTAssertEqual(result, value)
    }
  }

  func testWithInvalidFormattedJSONString() throws {
    let data = [
      "",
      .randomBoolString(),
      .randomNumericString(of: 10),
      .randomAlphaNumericString(of: 20),
    ]
    .map { try! jsonEncoder.encode($0) }

    for data in data {
      dataCorrupted(from: data) { context in
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

  }

  func testWithInvalidTypeJSON() throws {
    let list: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Bool.random(),
      [Int](),
    ]

    let data =
      list
      .map { try! jsonEncoder.encode($0) }

    for data in data {
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertTrue(context.codingPath.isEmpty)
        XCTAssertNil(context.underlyingError)
      }
    }

  }

}
