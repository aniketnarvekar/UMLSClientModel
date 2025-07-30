// UMLSSemanticValueTests.swift

import Random
import XCTest

@testable import UMLSClientModel

final class UMLSSemanticValueTests: XCTestCase {

  var decoder: JSONDecoder!
  var encoder: JSONEncoder!

  override func setUp() {
    self.decoder = .init()
    self.encoder = .init()
  }

  func testWithSemanticTypeJSONString() throws {
    let data = try encoder.encode(UMLSSemanticType.allCases)
    let result = try decoder.decode([UMLSSemanticValue].self, from: data)
    for (result, type) in zip(result, UMLSSemanticType.allCases) {
      guard case UMLSSemanticValue.semanticType(let value) = result else {
        return XCTFail("Unexpected value: \(result)")
      }
      XCTAssertEqual(value, type)
    }
  }

  func testWithSemanticTypeRelationLabelJSONString() throws {
    let data = try encoder.encode(UMLSSemanticTypeRelationLabel.allCases)
    let result = try decode([UMLSSemanticValue].self, from: data)
    for (result, label) in zip(result, UMLSSemanticTypeRelationLabel.allCases) {
      guard case UMLSSemanticValue.relation(let value) = result else {
        return XCTFail("Unexpected value: \(result)")
      }
      XCTAssertEqual(value, label)
    }
  }

  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    try decoder.decode(type, from: data)
  }

  func dataCorrupted<T: Encodable>(value: T) throws {
    let data = try encoder.encode(value)
    XCTAssertThrowsError(try decode(UMLSSemanticValue.self, from: data)) { error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        return XCTFail("Unexpected Error: \(error)")
      }
      XCTAssert(context.codingPath.isEmpty)
      XCTAssertEqual(
        context.debugDescription,
        "Cannot initialize UMLSSemanticValue from invalid String value \(value)")
    }
  }

  func testWithInvalidJSONString() throws {
    let string = String.randomAlphaNumericString(of: 10)
    try dataCorrupted(value: string)
  }

  func testWithInsensitiveSemanticTypeJSONStirng() throws {
    let strings = UMLSSemanticType.allCases.map { $0.rawValue.uppercased() }
    for string in strings {
      try dataCorrupted(value: string)
    }
  }

  func testEncodeObject() throws {
    let times = Int.random(in: 10...20)
    for _ in (0...times) {
      let object = UMLSSemanticValue.random()
      let data = try encoder.encode(object)
      let result = try decoder.decode(UMLSSemanticValue.self, from: data)
      XCTAssertEqual(result, object)
    }
  }

}
