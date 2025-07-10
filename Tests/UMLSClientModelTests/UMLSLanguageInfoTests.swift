import Foundation
import Random
import XCTest

@testable import UMLSClientModel

// MARK: - JSONDecodeLanguageInfoTests

final class JSONDecodeLanguageInfoTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSLanguageInfo

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func jsonData(
    abbreviation: JSONValue<Any> = .present(UMLSLanguageAbbreviation.random().rawValue),
    name: JSONValue<Any> = .present(UMLSLanguageName.random().rawValue)
  ) throws -> Data {
    let dictionary = JSONSerializationDictionary.languageInfo(
      abbreviation: abbreviation, name: name)
    return try JSONSerialization.data(withJSONObject: dictionary)
  }

  func testWithValidJSON() throws {
    let abbreviation = UMLSLanguageAbbreviation.random()
    let name = UMLSLanguageName.random()
    let data = try jsonData(
      abbreviation: .present(abbreviation.rawValue),
      name: .present(name.rawValue))

    let result = try toObject(from: data)
    XCTAssertEqual(result.abbreviation, abbreviation)
    XCTAssertEqual(result.name, name)
  }

  func testWithInvalidAbbreviationFormattedJSONString() throws {
    let data = try jsonData(abbreviation: .present(String.randomAlphaNumericString(of: 10)))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingAbbreviation() throws {
    let data = try jsonData(abbreviation: .absent)
    keyNotFound(from: data) { codingKey, context in
      XCTAssertEqual(codingKey.stringValue, "abbreviation")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullAbbreviation() throws {
    let data = try jsonData(abbreviation: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidAbbreviationKeyType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 1.0..<10.0),
      Bool.random(),
    ]

    for element in list {
      let data = try jsonData(abbreviation: .present(element))
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
        XCTAssertNil(context.underlyingError)
      }
    }

  }

  func testWithInvalidExpanedFormFormattedJSONStirng() throws {
    let data = try jsonData(name: .present(String.randomAlphaNumericString(of: 10)))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullExpandedForm() throws {
    let data = try jsonData(name: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingExpandedForm() throws {
    let data = try jsonData(name: .absent)
    keyNotFound(from: data) { key, context in
      XCTAssertEqual(key.stringValue, "expandedForm")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithExpandedFormKeyType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 1.0..<10.0),
      Bool.random(),
    ]

    for element in list {
      let data = try jsonData(name: .present(element))
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
        XCTAssertNil(context.underlyingError)
      }
    }

  }

}

final class JSONEncodingLanaguageInfo: XCTestCase {

  var encoder: JSONEncoder!
  var decoder: JSONDecoder!

  override func setUp() {
    super.setUp()
    self.encoder = .init()
    self.decoder = .init()
  }

  override func tearDown() {
    super.tearDown()
    self.encoder = nil
    self.decoder = nil
  }

  func testWithValidJSON() throws {
    let object = UMLSLanguageInfo.random()
    let data = try encoder.encode(object)
    let result = try decoder.decode(UMLSLanguageInfo.self, from: data)
    XCTAssertEqual(object, result)
  }

}
