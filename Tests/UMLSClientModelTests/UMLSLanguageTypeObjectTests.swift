// UMLSLanguageTypeObjectTests.swift

import Foundation
import Random
import XCTest

@testable import UMLSClientModel

// MARK: - DecodeUMLSLanguageTypeObject

final class DecodeUMLSLanguageTypeObject: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSLanguageTypeObject<UMLSLanguageInfo>

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func jsonData(classType: JSONValue<Any> = .present(UMLSObject.language.rawValue)) -> Data {
    let dictionary = JSONSerializationDictionary.languageInfo(classType: classType)
    return try! JSONSerialization.data(withJSONObject: dictionary)
  }

  func testWithValidClassName() throws {
    XCTAssertNoThrow(try toObject(from: jsonData()))
  }

  func testWithUnsupportedClassName() throws {
    var data = jsonData(classType: .present(UMLSObject.contentInfo.rawValue))
    XCTAssertThrowsError(try toObject(from: data))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "classType")
      XCTAssertNil(context.underlyingError)
      XCTAssertEqual(context.debugDescription, "Unsupported class type ContactInformation")
    }

    data = jsonData(classType: .present(String.randomAlphaNumericString(of: 10)))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "classType")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testMissingClassType() throws {
    let data = jsonData(classType: .absent)
    XCTAssertThrowsError(try toObject(from: data))
    keyNotFound(from: data) { key, context in
      XCTAssertEqual(key.stringValue, "classType")
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testNullClassType() throws {
    let data = jsonData(classType: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "classType")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidClassTypeKeyType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 1.0..<10.0),
      Bool.random(),
    ]

    for element in list {
      let data = jsonData(classType: .present(element))
      typeMismatch(from: data) { type, context in
        XCTAssert(type is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "classType")
        XCTAssertNil(context.underlyingError)
      }
    }

  }

}

final class EncodeUMLSLanguageTypeObjectTests: XCTestCase {

  var decoder: JSONDecoder!
  var encoder: JSONEncoder!

  override func setUp() {
    super.setUp()
    self.decoder = .init()
    self.encoder = .init()
  }

  override func tearDown() {
    super.tearDown()
    self.decoder = nil
    self.encoder = nil
  }

  func testWithValidObject() throws {
    let object = UMLSLanguageTypeObject<UMLSLanguageInfo>.random()
    let data = try encoder.encode(object)
    let result = try decoder.decode(UMLSLanguageTypeObject<UMLSLanguageInfo>.self, from: data)
    XCTAssertTrue(object == result)
  }

}
