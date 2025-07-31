// EncodeUMLSSourceVocabularyInfoTests.swift

import Foundation
import Random
import XCTest

@testable import UMLSClientModel

final class EncodeUMLSSourceVocabularyInfoTests: XCTestCase, JSONCodable {

  struct SourceVocabularyInfoStringProperty {
    let codingPath: String
    let completionHandler:
      (String) ->
        UMLSSourceVocabularyInfo<
          UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
          UMLSLicenseContact<UMLSPostalAddress>
        >
  }

  struct SourceVocabularyInfoStringNilProperty {
    let completion:
      (String?) -> UMLSSourceVocabularyInfo<
        UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
        UMLSLicenseContact<UMLSPostalAddress>
      >
    let assertion:
      (
        UMLSSourceVocabularyInfo<
          UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
          UMLSLicenseContact<UMLSPostalAddress>
        >
      ) throws -> Void
  }

  typealias Object = UMLSSourceVocabularyInfo<
    UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
    UMLSLicenseContact<UMLSPostalAddress>
  >

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

  func testValidObject() throws {
    let object = UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >.randomInitializer()
    let data = try toData(object)
    let result = try toObject(data)
    XCTAssertEqual(object, result)
  }

  var objects: [SourceVocabularyInfoStringProperty] = [
    .init(codingPath: "abbreviation") { stringValue in
      .randomInitializer(abbreviation: stringValue)
    },
    .init(codingPath: "expandedForm") { stringValue in
      .randomInitializer(expandedForm: stringValue)
    },
    .init(codingPath: "family") { stringValue in
      .randomInitializer(family: stringValue)
    },
    .init(codingPath: "preferredName") { stringValue in
      .randomInitializer(preferredName: stringValue)
    },
    .init(codingPath: "shortName") { stringValue in
      .randomInitializer(shortName: stringValue)
    },
  ]

  func testInvalidStringProperties() throws {
    let strings: [String] = ["", .none, " ", "\n"]
    try objects.forEach { property in
      try strings.forEach { str in
        let object = property.completionHandler(str)
        do {
          _ = try toObject(try toData(object))
        } catch DecodingError.dataCorrupted(let context) {
          XCTAssertFalse(context.codingPath.isEmpty)
          XCTAssertEqual(context.codingPath.count, 1)
          XCTAssertEqual(context.codingPath.first!.stringValue, property.codingPath)
        }
      }
    }
  }

  var sourceVocabularyInfoStringNilProperties: [SourceVocabularyInfoStringNilProperty] = [
    .init { string in
      .randomInitializer(acquisitionContact: string)
    } assertion: { object in
      XCTAssertNil(object.acquisitionContact)
    },
    .init { string in
      .randomInitializer(hierarchicalName: string)
    } assertion: { object in
      XCTAssertNil(object.hierarchicalName)
    },
    .init { stringOrNil in
      .randomInitializer(synonymousNames: stringOrNil)
    } assertion: { object in
      XCTAssertNil(object.synonymousNames)
    },
  ]

  func testNilStringProperties() throws {
    try sourceVocabularyInfoStringNilProperties.forEach { object in
      try [nil, String.none, "", " ", "\n"].forEach { value in
        let sourceVocabularyInfoObject = object.completion(value)
        let decodedObject = try toObject(try toData(sourceVocabularyInfoObject))
        try object.assertion(decodedObject)
      }
    }
  }

  func testRestrictionLevel() throws {
    let restrictionLevel = UMLSSourceRestrictionLevel.random()
    let object = UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >.randomInitializer(restrictionLevel: restrictionLevel)
    XCTAssertEqual(object.restrictionLevel, restrictionLevel)
  }

  func testLanguage() throws {
    let languageInfo = UMLSLanguageTypeObject<UMLSLanguageInfo>.random()
    let object = UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >.randomInitializer(language: languageInfo)
    XCTAssertEqual(object.language, languageInfo)
  }

  func testCreatorContact() throws {
    let contentContact = UMLSContactInformationTypeObject<UMLSCreatorContact<UMLSPostalAddress>>
      .random()
    let object = UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >.randomInitializer(contentContact: contentContact)
    XCTAssertEqual(object.contentContact, contentContact)
  }

  func testLicenseContact() throws {
    let contentContact = UMLSContactInformationTypeObject<UMLSLicenseContact<UMLSPostalAddress>>
      .random()
    let object = UMLSSourceVocabularyInfo<
      UMLSLanguageTypeObject<UMLSLanguageInfo>, UMLSCreatorContact<UMLSPostalAddress>,
      UMLSLicenseContact<UMLSPostalAddress>
    >.randomInitializer(licenseContact: contentContact)
    XCTAssertEqual(object.licenseContact, contentContact)

  }

}
