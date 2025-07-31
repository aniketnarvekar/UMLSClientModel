// UMLSSourceVocabularyTypeObjectTests.swift

import Foundation
import Random
import XCTest

@testable import UMLSClientModel

final class DecodeUMLSSourceVocabularyTypeObjectTests: XCTestCase, JSONCodable {
  typealias Object = UMLSSourceVocabularyTypeObject<
    UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >
  >

  var encoder: JSONEncoder!

  var decoder: JSONDecoder!

  override func setUp() {
    super.setUp()
    self.encoder = .init()
    self.decoder = .init()
  }

  func testValid() throws {
    let object = Object.random()
    let data = try toData(object)
    let result = try toObject(data)
    XCTAssertEqual(result, object)
  }

  func testUnsupportedClassType() throws {
    let jsonData = """
      {"abbreviation":"drdiglo5Bv","expandedForm":"gcPL3nugWF","contextType":"NONE","family":"z8pW1BKuNg","shortName":"VrUribU67m","hierarchicalName":"wfHxRofaSd","acquisitionContact":"dYXJdxRF85","licenseContact":{"email":"Je4GEpEOFA","city":"3QNWKbxq2L","value":"RZJU8eYR7S","handle":"fmDHnDI7W1","telephone":"ZL6QfOln6p","stateOrProvince":"VqcHPOWxzH","organization":"H5V5ZmjLyD","title":"ZxkQdAJqX6","fax":"QtdB5g1oQk","address1":"c5ZM1TePGl","classType":"ContactInformation","country":"CStsC3QIVQ","name":"s9wObEeKdd","address2":"Cqwld2Ntlh","url":"https://github.com/","zipCode":"JnqpM9JQdm"},"classType":"ContactInformation","restrictionLevel":0,"synonymousNames":"xBBcD6VNY3","language":{"expandedForm":"Latvian","classType":"Language","abbreviation":"UKR"},"preferredName":"iwkGSTknS2","contentContact":{"email":"OXNocD5BZo","city":"MGNw8wPGC5","value":"mfBskOH2J0","handle":"51446229993","telephone":"gJeqaeo8Q8","stateOrProvince":"278psB2eO1","organization":"My5RjHU0EB","title":"De3NNkSydJ","fax":"9S0s29y3eY","address1":"auZLSqkSME","classType":"ContactInformation","country":"EOrvF8GOQK","name":"pEgeXVlChU","address2":"uZ3qqh04cq","url":"https://github.com/","zipCode":"66BkL6JQlU"}}
      """.data(using: .utf8)!
    do {
      _ = try toObject(jsonData)
    } catch let error as DecodingError {
      guard case DecodingError.dataCorrupted(let context) = error else {
        throw error
      }
      context.assertContext(codingPath: "classType")
    }
  }

  func testInvalidClassType() throws {
    let jsonData = """
      {"abbreviation":"drdiglo5Bv","expandedForm":"gcPL3nugWF","contextType":"NONE","family":"z8pW1BKuNg","shortName":"VrUribU67m","hierarchicalName":"wfHxRofaSd","acquisitionContact":"dYXJdxRF85","licenseContact":{"email":"Je4GEpEOFA","city":"3QNWKbxq2L","value":"RZJU8eYR7S","handle":"fmDHnDI7W1","telephone":"ZL6QfOln6p","stateOrProvince":"VqcHPOWxzH","organization":"H5V5ZmjLyD","title":"ZxkQdAJqX6","fax":"QtdB5g1oQk","address1":"c5ZM1TePGl","classType":"ContactInformation","country":"CStsC3QIVQ","name":"s9wObEeKdd","address2":"Cqwld2Ntlh","url":"https://github.com/","zipCode":"JnqpM9JQdm"},"classType":"rootsource","restrictionLevel":0,"synonymousNames":"xBBcD6VNY3","language":{"expandedForm":"Latvian","classType":"Language","abbreviation":"UKR"},"preferredName":"iwkGSTknS2","contentContact":{"email":"OXNocD5BZo","city":"MGNw8wPGC5","value":"mfBskOH2J0","handle":"51446229993","telephone":"gJeqaeo8Q8","stateOrProvince":"278psB2eO1","organization":"My5RjHU0EB","title":"De3NNkSydJ","fax":"9S0s29y3eY","address1":"auZLSqkSME","classType":"ContactInformation","country":"EOrvF8GOQK","name":"pEgeXVlChU","address2":"uZ3qqh04cq","url":"https://github.com/","zipCode":"66BkL6JQlU"}}
      """.data(using: .utf8)!
    do {
      _ = try toObject(jsonData)
    } catch let error as DecodingError {
      guard case DecodingError.dataCorrupted(let context) = error else {
        throw error
      }
      context.assertContext(codingPath: "classType")
    }
  }

  func testInvalidClassTypeDataType() throws {
    let jsonData = """
      {"abbreviation":"drdiglo5Bv","expandedForm":"gcPL3nugWF","contextType":"NONE","family":"z8pW1BKuNg","shortName":"VrUribU67m","hierarchicalName":"wfHxRofaSd","acquisitionContact":"dYXJdxRF85","licenseContact":{"email":"Je4GEpEOFA","city":"3QNWKbxq2L","value":"RZJU8eYR7S","handle":"fmDHnDI7W1","telephone":"ZL6QfOln6p","stateOrProvince":"VqcHPOWxzH","organization":"H5V5ZmjLyD","title":"ZxkQdAJqX6","fax":"QtdB5g1oQk","address1":"c5ZM1TePGl","classType":"ContactInformation","country":"CStsC3QIVQ","name":"s9wObEeKdd","address2":"Cqwld2Ntlh","url":"https://github.com/","zipCode":"JnqpM9JQdm"},"classType":123,"restrictionLevel":0,"synonymousNames":"xBBcD6VNY3","language":{"expandedForm":"Latvian","classType":"Language","abbreviation":"UKR"},"preferredName":"iwkGSTknS2","contentContact":{"email":"OXNocD5BZo","city":"MGNw8wPGC5","value":"mfBskOH2J0","handle":"51446229993","telephone":"gJeqaeo8Q8","stateOrProvince":"278psB2eO1","organization":"My5RjHU0EB","title":"De3NNkSydJ","fax":"9S0s29y3eY","address1":"auZLSqkSME","classType":"ContactInformation","country":"EOrvF8GOQK","name":"pEgeXVlChU","address2":"uZ3qqh04cq","url":"https://github.com/","zipCode":"66BkL6JQlU"}}
      """.data(using: .utf8)!
    do {
      _ = try toObject(jsonData)
    } catch let error as DecodingError {
      guard case DecodingError.typeMismatch(let type, let context) = error else {
        throw error
      }
      XCTAssert(type is String.Type)
      context.assertContext(codingPath: "classType")
    }
  }

  func testNullClassType() throws {
    let jsonData = """
      {"abbreviation":"drdiglo5Bv","expandedForm":"gcPL3nugWF","contextType":"NONE","family":"z8pW1BKuNg","shortName":"VrUribU67m","hierarchicalName":"wfHxRofaSd","acquisitionContact":"dYXJdxRF85","licenseContact":{"email":"Je4GEpEOFA","city":"3QNWKbxq2L","value":"RZJU8eYR7S","handle":"fmDHnDI7W1","telephone":"ZL6QfOln6p","stateOrProvince":"VqcHPOWxzH","organization":"H5V5ZmjLyD","title":"ZxkQdAJqX6","fax":"QtdB5g1oQk","address1":"c5ZM1TePGl","classType":"ContactInformation","country":"CStsC3QIVQ","name":"s9wObEeKdd","address2":"Cqwld2Ntlh","url":"https://github.com/","zipCode":"JnqpM9JQdm"},"classType":null,"restrictionLevel":0,"synonymousNames":"xBBcD6VNY3","language":{"expandedForm":"Latvian","classType":"Language","abbreviation":"UKR"},"preferredName":"iwkGSTknS2","contentContact":{"email":"OXNocD5BZo","city":"MGNw8wPGC5","value":"mfBskOH2J0","handle":"51446229993","telephone":"gJeqaeo8Q8","stateOrProvince":"278psB2eO1","organization":"My5RjHU0EB","title":"De3NNkSydJ","fax":"9S0s29y3eY","address1":"auZLSqkSME","classType":"ContactInformation","country":"EOrvF8GOQK","name":"pEgeXVlChU","address2":"uZ3qqh04cq","url":"https://github.com/","zipCode":"66BkL6JQlU"}}
      """.data(using: .utf8)!
    do {
      _ = try toObject(jsonData)
    } catch let error as DecodingError {
      guard case DecodingError.valueNotFound(let type, let context) = error else {
        throw error
      }
      XCTAssert(type is String.Type)
      context.assertContext(codingPath: "classType")
    }
  }

  func testAbsentClassType() throws {
    let jsonData = """
      {"abbreviation":"drdiglo5Bv","expandedForm":"gcPL3nugWF","contextType":"NONE","family":"z8pW1BKuNg","shortName":"VrUribU67m","hierarchicalName":"wfHxRofaSd","acquisitionContact":"dYXJdxRF85","licenseContact":{"email":"Je4GEpEOFA","city":"3QNWKbxq2L","value":"RZJU8eYR7S","handle":"fmDHnDI7W1","telephone":"ZL6QfOln6p","stateOrProvince":"VqcHPOWxzH","organization":"H5V5ZmjLyD","title":"ZxkQdAJqX6","fax":"QtdB5g1oQk","address1":"c5ZM1TePGl","classType":"ContactInformation","country":"CStsC3QIVQ","name":"s9wObEeKdd","address2":"Cqwld2Ntlh","url":"https://github.com/","zipCode":"JnqpM9JQdm"},"restrictionLevel":0,"synonymousNames":"xBBcD6VNY3","language":{"expandedForm":"Latvian","classType":"Language","abbreviation":"UKR"},"preferredName":"iwkGSTknS2","contentContact":{"email":"OXNocD5BZo","city":"MGNw8wPGC5","value":"mfBskOH2J0","handle":"51446229993","telephone":"gJeqaeo8Q8","stateOrProvince":"278psB2eO1","organization":"My5RjHU0EB","title":"De3NNkSydJ","fax":"9S0s29y3eY","address1":"auZLSqkSME","classType":"ContactInformation","country":"EOrvF8GOQK","name":"pEgeXVlChU","address2":"uZ3qqh04cq","url":"https://github.com/","zipCode":"66BkL6JQlU"}}
      """.data(using: .utf8)!
    do {
      _ = try toObject(jsonData)
    } catch let error as DecodingError {
      guard case DecodingError.keyNotFound(let key, let context) = error else {
        throw error
      }
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertEqual(key.stringValue, "classType")
    }
  }

}

// MARK: - EncodeUMLSSourceVocabularyTypeObjectTests

final class EncodeUMLSSourceVocabularyTypeObjectTests: XCTestCase, JSONCodable {

  typealias Object = UMLSSourceVocabularyTypeObject<
    UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >
  >

  var encoder: JSONEncoder!

  var decoder: JSONDecoder!

  override func setUp() {
    self.encoder = .init()
    self.decoder = .init()
  }

  func testValid() throws {
    XCTAssertNoThrow(try randomObjectToData())
  }

}
