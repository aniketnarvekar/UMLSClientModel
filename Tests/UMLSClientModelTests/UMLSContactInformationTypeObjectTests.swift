// UMLSContactInformationTypeObjectTests.swift

import Foundation
import Random
import XCTest

@testable import UMLSClientModel

// MARK: - UMLSContactInformationTypeObjectTests

final class UMLSContactInformationTypeObjectTests: XCTestCase,
  XCTDecodingErrorAssertion
{
  typealias Element = UMLSContactInformationTypeObject<
    UMLSCreatorContact<UMLSPostalAddress>
  >

  var jsonEncoder: JSONEncoder!
  var jsonDecoder: JSONDecoder!

  func jsonData(
    classType: JSONValue<Any> = .present("ContactInformation")
  ) -> Data {
    let dict = JSONSerializationDictionary.creatorContact(
      classType: classType
    )
    return try! JSONSerialization.data(withJSONObject: dict)
  }

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func assertTypeMismatch(from data: Data, _ string: String) {
    typeMismatch(from: data) { type, context in
      XCTAssert(type is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, string)
      XCTAssertNil(context.underlyingError)
    }
  }

  func assertMissing(from data: Data, _ string: String) {
    keyNotFound(from: data) { key, context in
      XCTAssertEqual(key.stringValue, string)
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNil(context.underlyingError)
    }
  }

  func assertNull(from data: Data, _ string: String) {
    valueNotFound(from: data) { type, context in
      XCTAssert(type is String.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, string)
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithValidClassType() throws {
    let data = jsonData()
    XCTAssertNoThrow(try toObject(from: data))
  }

  func testWithInvalidClassType() throws {
    let strings: [String] = [
      "", .randomBoolString(), .randomNumericString(of: 10), .randomAlphaNumericString(of: 10),
    ]
    for string in strings {
      let data = jsonData(classType: .present(string))
      dataCorrupted(from: data) { context in
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "classType")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testInvalidClassTypeType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(classType: .present(element))
      assertTypeMismatch(from: data, "classType")
    }

  }

  func testMissingClassType() throws {
    let data = jsonData(classType: .absent)
    assertMissing(from: data, "classType")
  }

  func testNullClassType() throws {
    let data = jsonData(classType: .present(nil))
    assertNull(from: data, "classType")
  }

  func testUnsupportedClassType() throws {
    let data = jsonData(classType: .present(UMLSObject.language.rawValue))
    do {
      _ = try self.jsonDecoder.decode(Element.self, from: data)
    } catch let error as DecodingError {
      guard case DecodingError.dataCorrupted(let context) = error else {
        throw error
      }
      context.assertContext(codingPath: "classType")
    }
  }

}

final class EncodeUMLSContactInformationTypeObjectTests: XCTestCase, JSONCodable {

  typealias Object = UMLSContactInformationTypeObject<UMLSCreatorContact<UMLSPostalAddress>>

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

  func testValidObject() throws {
    let object = UMLSContactInformationTypeObject<UMLSCreatorContact<UMLSPostalAddress>>.random()
    let data = try toData(object)
    let result = try toObject(data)
    XCTAssertEqual(result, object)
  }

}
