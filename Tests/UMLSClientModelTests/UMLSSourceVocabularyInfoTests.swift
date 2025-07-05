// UMLSSourceVocabulary.swift

import Foundation
import Random
import XCTest

@testable import UMLSClientModel

// MARK: - UMLSSourceVocabularyInfoTests

final class UMLSSourceVocabularyInfoTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSSourceVocabularyInfo<
    UMLSLanguageInfo, UMLSCreatorContact<UMLSPostalAddress>, UMLSLicenseContact<UMLSPostalAddress>
  >

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func jsonData(
    classType: JSONValue<Any> = .present("RootSource"),
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    expandedForm: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    family: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    language: JSONValue<Any> = .present(JSONSerializationDictionary.languageInfo()),
    restrictionLevel: JSONValue<Any> = .present(UMLSSourceRestrictionLevel.random().rawValue),
    acquisitionContact: JSONValue<Any> = .present(
      ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!),
    contentContact: JSONValue<Any> = .present(JSONSerializationDictionary.creatorContact()),
    licenseContact: JSONValue<Any> = .present(JSONSerializationDictionary.creatorContact()),
    contextType: JSONValue<Any> = .present(UMLSContextType.random().rawValue),
    shortName: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    hierarchicalName: JSONValue<Any> = .present(
      ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!),
    preferredName: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    synonymousNames: JSONValue<Any> = .present(
      ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!)
  ) -> Data {
    let dictionary = JSONSerializationDictionary.sourceVocabulary(
      classType: classType, abbreviation: abbreviation, expanededForm: expandedForm,
      family: family, language: language, restrictionLevel: restrictionLevel,
      acquisitionContact: acquisitionContact, contentContact: contentContact,
      licenseContact: licenseContact, contextType: contextType, shortName: shortName,
      hierarchicalName: hierarchicalName, preferredName: preferredName,
      synonymousNames: synonymousNames)
    return try! JSONSerialization.data(withJSONObject: dictionary)
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

  // MARK: Abbreviation

  func testWithValidAbbreviation() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(abbreviation: .present(string))
    let result = try toObject(from: data).abbreviation
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, string)
  }

  func testWithNONEAbbreviation() throws {
    let data = jsonData(abbreviation: .present(String.none))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithEmptyAbbreviation() throws {
    let data = jsonData(abbreviation: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidAbbreviationTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(abbreviation: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "abbreviation")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingAbbreviation() throws {
    let data = jsonData(abbreviation: .absent)
    assertMissing(from: data, "abbreviation")
  }

  func testNullAbbreviation() throws {
    let data = jsonData(abbreviation: .present(nil))
    assertNull(from: data, "abbreviation")
  }

  func testWithAbbreviationPrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(abbreviation: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.abbreviation)
      XCTAssertEqual(result.abbreviation, "xyz")
    }
  }

  // MARK: expandedForm

  func testWithValidExpandedForm() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(expandedForm: .present(string))
    let result = try toObject(from: data).expandedForm
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, string)
  }

  func testWithNONEExpandedForm() throws {
    let data = jsonData(expandedForm: .present(String.none))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithEmptyExpandedForm() throws {
    let data = jsonData(expandedForm: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidExpandedFormTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(expandedForm: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "expandedForm")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingExpandedForm() throws {
    let data = jsonData(expandedForm: .absent)
    assertMissing(from: data, "expandedForm")
  }

  func testNullExpandedForm() throws {
    let data = jsonData(expandedForm: .present(nil))
    assertNull(from: data, "expandedForm")
  }

  func testWithExpandedFormPrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(expandedForm: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.expandedForm)
      XCTAssertEqual(result.expandedForm, "xyz")
    }
  }

  // MARK: family

  func testWithValidFamily() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(family: .present(string))
    let result = try toObject(from: data).family
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, string)
  }

  func testWithNONEFamily() throws {
    let data = jsonData(family: .present(String.none))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "family")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithEmptyFamily() throws {
    let data = jsonData(family: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "family")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidFamilyTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(family: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "family")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingFamily() throws {
    let data = jsonData(family: .absent)
    assertMissing(from: data, "family")
  }

  func testNullFamily() throws {
    let data = jsonData(family: .present(nil))
    assertNull(from: data, "family")
  }

  func testWithFamilyPrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(family: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.family)
      XCTAssertEqual(result.family, "xyz")
    }
  }

  // MARK: shortName

  func testWithValidShortName() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(shortName: .present(string))
    let result = try toObject(from: data).shortName
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, string)
  }

  func testWithNONEShortName() throws {
    let data = jsonData(shortName: .present(String.none))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "shortName")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithEmptyShortName() throws {
    let data = jsonData(shortName: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "shortName")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidShortNameTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(shortName: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "shortName")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingShortName() throws {
    let data = jsonData(shortName: .absent)
    assertMissing(from: data, "shortName")
  }

  func testNullShortName() throws {
    let data = jsonData(shortName: .present(nil))
    assertNull(from: data, "shortName")
  }

  func testWithShortNamePrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(shortName: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.shortName)
      XCTAssertEqual(result.shortName, "xyz")
    }
  }

  // MARK: preferredName

  func testWithValidPreferredName() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(preferredName: .present(string))
    let result = try toObject(from: data).preferredName
    XCTAssertFalse(result.isEmpty)
    XCTAssertEqual(result, string)
  }

  func testWithNONEPreferredName() throws {
    let data = jsonData(preferredName: .present(String.none))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "preferredName")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithEmptyPreferredName() throws {
    let data = jsonData(preferredName: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "preferredName")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidPreferredNameTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(preferredName: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "preferredName")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingPreferredName() throws {
    let data = jsonData(preferredName: .absent)
    assertMissing(from: data, "preferredName")
  }

  func testNullPreferredName() throws {
    let data = jsonData(preferredName: .present(nil))
    assertNull(from: data, "preferredName")
  }

  func testWithPreferredNamePrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(preferredName: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.preferredName)
      XCTAssertEqual(result.preferredName, "xyz")
    }
  }

  // MARK: acquisitionContact

  func testWithValidAcquisitionContact() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(acquisitionContact: .present(string))
    let result = try toObject(from: data).acquisitionContact
    XCTAssertEqual(result, string)
  }

  func testWithNONEAcquisitionContact() throws {
    let data = jsonData(acquisitionContact: .present(String.none))
    let result = try toObject(from: data).acquisitionContact
    XCTAssertNil(result)
  }

  func testWithEmptyAcquisitionContact() throws {
    let data = jsonData(acquisitionContact: .present(""))
    let object = try toObject(from: data)
    XCTAssertNil(object.acquisitionContact)
  }

  func testWithInvalidAcquisitionContactTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(acquisitionContact: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "acquisitionContact")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingAcquisitionContact() throws {
    let data = jsonData(acquisitionContact: .absent)
    assertMissing(from: data, "acquisitionContact")
  }

  func testNullAcquisitionContact() throws {
    let data = jsonData(acquisitionContact: .present(nil))
    assertNull(from: data, "acquisitionContact")
  }

  func testWithAcquisitionContactPrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(acquisitionContact: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.acquisitionContact)
      XCTAssertEqual(result.acquisitionContact, "xyz")
    }
  }

  // MARK: hierarchicalName

  func testWithValidHierarchicalName() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(hierarchicalName: .present(string))
    let result = try toObject(from: data).hierarchicalName
    XCTAssertEqual(result, string)
  }

  func testWithNONEHierarchicalName() throws {
    let data = jsonData(hierarchicalName: .present(String.none))
    let result = try toObject(from: data).hierarchicalName
    XCTAssertNil(result)
  }

  func testWithEmptyHierarchicalName() throws {
    let data = jsonData(hierarchicalName: .present(""))
    let object = try toObject(from: data)
    XCTAssertNil(object.hierarchicalName)
  }

  func testWithInvalidHierarchicalNameTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(hierarchicalName: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "hierarchicalName")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingHierarchicalName() throws {
    let data = jsonData(hierarchicalName: .absent)
    assertMissing(from: data, "hierarchicalName")
  }

  func testNullHierarchicalName() throws {
    let data = jsonData(hierarchicalName: .present(nil))
    assertNull(from: data, "hierarchicalName")
  }

  func testWithHierarchicalNamePrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(hierarchicalName: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.hierarchicalName)
      XCTAssertEqual(result.hierarchicalName, "xyz")
    }
  }

  // MARK: synonymousNames

  func testWithValidSynonymousNames() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(synonymousNames: .present(string))
    let result = try toObject(from: data).synonymousNames
    XCTAssertEqual(result, string)
  }

  func testWithNONESynonymousNames() throws {
    let data = jsonData(synonymousNames: .present(String.none))
    let result = try toObject(from: data).synonymousNames
    XCTAssertNil(result)
  }

  func testWithEmptySynonymousNames() throws {
    let data = jsonData(synonymousNames: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "synonymousNames")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidSynonymousNamesTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(synonymousNames: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "synonymousNames")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingSynonymousNames() throws {
    let data = jsonData(synonymousNames: .absent)
    assertMissing(from: data, "synonymousNames")
  }

  func testNullSynonymousNames() throws {
    let data = jsonData(synonymousNames: .present(nil))
    assertNull(from: data, "synonymousNames")
  }

  func testWithSynonymousNamesPrefixSuffixWhitespaces() throws {
    let data = [" xyz", "xyz  ", "  xyz "].map { jsonData(synonymousNames: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.synonymousNames)
      XCTAssertEqual(result.synonymousNames, "xyz")
    }
  }

  // MARK: restrictionLevel

  func testWithNegativeRestrictionLevel() throws {
    let data = jsonData(restrictionLevel: .present(Int.random(in: Int.min..<0)))
    dataCorrupted(from: data) { context in
      XCTAssertTrue(context.codingPath.isEmpty)
      XCTAssertNotNil(context.underlyingError)
      let error = context.underlyingError! as NSError
      XCTAssertEqual(error.domain, NSCocoaErrorDomain)
      XCTAssertEqual(error.code, 3840)
    }
  }

  func testWithInvalidRestrictionLevelTypeJSON() throws {
    let values: [Encodable] = [
      Bool.random(),
      String.randomAlphaNumericString(of: 10),
    ]

    let data =
      values
      .map {
        jsonData(restrictionLevel: .present($0))
      }

    for data in data {
      XCTAssertThrowsError(try toObject(from: data))
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is UInt8.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "restrictionLevel")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingRestrictionLevel() throws {
    let data = jsonData(restrictionLevel: .absent)
    assertMissing(from: data, "restrictionLevel")
  }

  func testNullRestrictionLevel() throws {
    let data = jsonData(restrictionLevel: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is UInt8.Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "restrictionLevel")
      XCTAssertNil(context.underlyingError)
    }
  }

  // MARK: language

  func testWithValidLangauge() throws {
    let dictionary = JSONSerializationDictionary.languageInfo()
    let data = jsonData(language: .present(dictionary))
    XCTAssertNoThrow(try toObject(from: data))
  }

  func testWithInvalidLanguageTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(language: .present($0))
      }

    for data in data {
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is [String: Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "language")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingLanguage() throws {
    let data = jsonData(language: .absent)
    assertMissing(from: data, "language")
  }

  func testNullLanguage() throws {
    let data = jsonData(language: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is [String: Any].Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "language")
      XCTAssertNil(context.underlyingError)
    }
  }

  // MARK: contentContact

  func testWithValidContentContact() throws {
    let dictionary = JSONSerializationDictionary.creatorContact()
    let data = jsonData(contentContact: .present(dictionary))
    XCTAssertNoThrow(try toObject(from: data))
  }

  func testWithInvalidContentContactTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(contentContact: .present($0))
      }

    for data in data {
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is [String: Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "contentContact")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingContentContact() throws {
    let data = jsonData(contentContact: .absent)
    assertMissing(from: data, "contentContact")
  }

  func testNullContentContact() throws {
    let data = jsonData(contentContact: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is [String: Any].Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "contentContact")
      XCTAssertNil(context.underlyingError)
    }
  }

  // MARK: licenseContact

  func testWithValidLicenseContact() throws {
    let dictionary = JSONSerializationDictionary.creatorContact()
    let data = jsonData(licenseContact: .present(dictionary))
    XCTAssertNoThrow(try toObject(from: data))
  }

  func testWithInvalidLicenseContactTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(licenseContact: .present($0))
      }

    for data in data {
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is [String: Any].Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "licenseContact")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingLicenseContact() throws {
    let data = jsonData(licenseContact: .absent)
    assertMissing(from: data, "licenseContact")
  }

  func testNullLicenseContact() throws {
    let data = jsonData(licenseContact: .present(nil))
    valueNotFound(from: data) { type, context in
      XCTAssert(type is [String: Any].Type)
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "licenseContact")
      XCTAssertNil(context.underlyingError)
    }
  }

  // MARK: contextType

  func testWithValidContextType() throws {
    let contextType = UMLSContextType.random().rawValue
    let data = jsonData(contextType: .present(contextType))
    let result = try toObject(from: data).contextType
    XCTAssertEqual(result.rawValue, contextType)
  }

  func testWithInvalidContextType() throws {
    let string = String.randomAlphaNumericString(of: 10)
    let data = jsonData(contextType: .present(string))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "contextType")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testWithInvalidContextTypeJSON() throws {
    let values: [Encodable] = [
      Int.random(in: Int.min...Int.max),
      Array<Int>.init(),
      (0..<10).map { $0 },
      Bool.random(),
    ]

    let data =
      values
      .map {
        jsonData(contextType: .present($0))
      }

    for data in data {
      typeMismatch(from: data) { typ, context in
        XCTAssert(typ is String.Type)
        XCTAssertFalse(context.codingPath.isEmpty)
        XCTAssertEqual(context.codingPath[0].stringValue, "contextType")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testMissingContextType() throws {
    let data = jsonData(contextType: .absent)
    assertMissing(from: data, "contextType")
  }

  func testNullContextType() throws {
    let data = jsonData(contextType: .present(nil))
    assertNull(from: data, "contextType")
  }

  func testWithContextTypePrefixSuffixWhitespaces() throws {
    let data = [
      " NONE", "NONE ", " NONE ", " FULL", "FULL ", "  FULL ", " FULL-MULTIPLE", "FULL-MULTIPLE ",
      " FULL-MULTIPLE ",
    ].map { jsonData(contextType: .present($0)) }

    for data in data {
      XCTAssertNoThrow(try toObject(from: data))
    }
  }

}
