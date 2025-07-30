// UMLSCreatorContactTests.swift

import Foundation
import Random
import XCTest

@testable import UMLSClientModel

// MARK: - DecodeUMLSCreatorContactTests

protocol JSONCodable {
  associatedtype Object: Codable
  var encoder: JSONEncoder! { get set }
  var decoder: JSONDecoder! { get set }
}

extension JSONCodable {

  func toObject(_ data: Data) throws -> Object {
    try decoder.decode(Object.self, from: data)
  }

  func toData(_ object: Object) throws -> Data {
    try encoder.encode(object)
  }

}

protocol EncoderTestsProtocol: JSONCodable {

  associatedtype DataType
  associatedtype AssociatedKey

  var nullEncodingStrings: [DataType?] { get }

  func initialize(forKey key: AssociatedKey, value: DataType?) -> Object
  func value(forkey key: AssociatedKey, from object: Object) -> DataType?
  func assertEncoding(forKey key: AssociatedKey) throws

}

extension EncoderTestsProtocol where DataType: StringProtocol {

  func __data(usingKey key: AssociatedKey) throws -> (DataType, Data) {
    let stringValue: DataType = String.randomAlphaNumericString(of: 10) as! DataType
    let object = initialize(forKey: key, value: stringValue)
    return (stringValue, try toData(object))
  }

  func assert(forKey key: AssociatedKey, value: DataType, from data: Data) throws {
    let object = try toObject(data)
    let stringOrNil = self.value(forkey: key, from: object)
    XCTAssertNotNil(stringOrNil)
    XCTAssertEqual(stringOrNil, value)
  }

  func assertEncoding(forKey key: AssociatedKey) throws {
    let (stringValue, data) = try __data(usingKey: key)
    try assert(forKey: key, value: stringValue, from: data)
  }

  func assertNull(forKey key: AssociatedKey) throws {
    try nullEncodingStrings.forEach { stringValue in
      let object = initialize(forKey: key, value: stringValue)
      let data = try toData(object)
      let result = try toObject(data)
      let value = self.value(forkey: key, from: result)
      XCTAssertNil(value)
    }
  }

}

final class DecodeUMLSCreatorContactTests: XCTestCase, XCTDecodingErrorAssertion {

  typealias Element = UMLSCreatorContact<UMLSPostalAddress>

  var jsonDecoder: JSONDecoder!
  var jsonEncoder: JSONEncoder!

  override func setUp() {
    self.jsonDecoder = .init()
    self.jsonEncoder = .init()
  }

  func jsonData(
    handle: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
    name: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    title: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    organization: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    address1: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    address2: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    city: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    stateOrProvince: JSONValue<Any> = .present(String.randomNumericString(of: 2)),
    country: JSONValue<Any> = .present(String.randomNumericString(of: 5)),
    zipCode: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 5)),
    telephone: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    fax: JSONValue<Any> = .present(String.randomNumericString(of: 10)),
    email: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    url: JSONValue<Any> = .present("http://localhost:8080"),
    value: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10))
  ) -> Data {
    let dict = JSONSerializationDictionary.creatorContact(
      handle: handle,
      name: name,
      title: title,
      organization: organization,
      address1: address1,
      address2: address2,
      city: city,
      stateOrProvince: stateOrProvince,
      country: country,
      zipCode: zipCode,
      telephone: telephone,
      fax: fax,
      email: email,
      url: url,
      value: value)
    return try! JSONSerialization.data(withJSONObject: dict)
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

  // MARK: HANDLE

  func testWithValidNonNONEHandle() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(handle: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.handle)
    XCTAssertEqual(result.handle!, string)
  }

  func testWithValidNONEHandle() throws {
    let data = jsonData(handle: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.handle)
  }

  func testWithEmptyHandle() throws {
    let data = jsonData(handle: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.handle)
  }

  func testInvalidHandleType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(handle: .present(element))
      assertTypeMismatch(from: data, "handle")
    }

  }

  func testMissingHandle() throws {
    let data = jsonData(handle: .absent)
    assertMissing(from: data, "handle")
  }

  func testNullHandle() throws {
    let data = jsonData(handle: .present(nil))
    assertNull(from: data, "handle")
  }

  func testWithHandlePrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(handle: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.handle)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(handle: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.handle)
      XCTAssertEqual(result.handle, "xyz")
    }

  }

  // MARK: name

  func testWithValidNonNONEName() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(name: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.name)
    XCTAssertEqual(result.name!, string)
  }

  func testWithValidNONEName() throws {
    let data = jsonData(name: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.name)
  }

  func testWithEmptyName() throws {
    let data = jsonData(name: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.name)
  }

  func testInvalidNameType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(name: .present(element))
      assertTypeMismatch(from: data, "name")
    }

  }

  func testMissingName() throws {
    let data = jsonData(name: .absent)
    assertMissing(from: data, "name")
  }

  func testNullName() throws {
    let data = jsonData(name: .present(nil))
    assertNull(from: data, "name")
  }

  func testWithNamePrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(name: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.name)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(name: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.name)
      XCTAssertEqual(result.name, "xyz")
    }

  }

  // MARK: title

  func testWithValidNonNONETitle() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(title: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.title)
    XCTAssertEqual(result.title!, string)
  }

  func testWithValidNONETitle() throws {
    let data = jsonData(title: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.title)
  }

  func testWithEmptyTitle() throws {
    let data = jsonData(title: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.title)
  }

  func testInvalidTitleType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(title: .present(element))
      assertTypeMismatch(from: data, "title")
    }

  }

  func testMissingTitle() throws {
    let data = jsonData(title: .absent)
    assertMissing(from: data, "title")
  }

  func testNullTitle() throws {
    let data = jsonData(title: .present(nil))
    assertNull(from: data, "title")
  }

  func testWithTitlePrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(title: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.title)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(title: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.title)
      XCTAssertEqual(result.title, "xyz")
    }

  }

  // MARK: organization

  func testWithValidNonNONEOrganization() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(organization: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.organization)
    XCTAssertEqual(result.organization!, string)
  }

  func testWithValidNONEOrganization() throws {
    let data = jsonData(organization: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.organization)
  }

  func testWithEmptyOrganization() throws {
    let data = jsonData(organization: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.organization)
  }

  func testInvalidOrganizationType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(organization: .present(element))
      assertTypeMismatch(from: data, "organization")
    }

  }

  func testMissingOrganization() throws {
    let data = jsonData(organization: .absent)
    assertMissing(from: data, "organization")
  }

  func testNullOrganization() throws {
    let data = jsonData(organization: .present(nil))
    assertNull(from: data, "organization")
  }

  func testWithOrganizationPrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(organization: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.organization)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(organization: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.organization)
      XCTAssertEqual(result.organization, "xyz")
    }
  }

  // MARK: telephone

  func testWithValidNonNONETelephone() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(telephone: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.telephone)
    XCTAssertEqual(result.telephone!, string)
  }

  func testWithValidNONETelephone() throws {
    let data = jsonData(telephone: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.telephone)
  }

  func testWithEmptyTelephone() throws {
    let data = jsonData(telephone: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.telephone)
  }

  func testInvalidTelephoneType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(telephone: .present(element))
      assertTypeMismatch(from: data, "telephone")
    }

  }

  func testMissingTelephone() throws {
    let data = jsonData(telephone: .absent)
    assertMissing(from: data, "telephone")
  }

  func testNullTelephone() throws {
    let data = jsonData(telephone: .present(nil))
    assertNull(from: data, "telephone")
  }

  func testWithTelephonePrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(telephone: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.telephone)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(telephone: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.telephone)
      XCTAssertEqual(result.telephone, "xyz")
    }

  }

  // MARK: fax

  func testWithValidNonNONEFax() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(fax: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.fax)
    XCTAssertEqual(result.fax!, string)
  }

  func testWithValidNONEFax() throws {
    let data = jsonData(fax: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.fax)
  }

  func testWithEmptyFax() throws {
    let data = jsonData(fax: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.fax)
  }

  func testInvalidFaxType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(fax: .present(element))
      assertTypeMismatch(from: data, "fax")
    }

  }

  func testMissingFax() throws {
    let data = jsonData(fax: .absent)
    assertMissing(from: data, "fax")
  }

  func testNullFax() throws {
    let data = jsonData(fax: .present(nil))
    assertNull(from: data, "fax")
  }

  func testWithFaxPrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(fax: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.fax)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(fax: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.fax)
      XCTAssertEqual(result.fax, "xyz")
    }

  }

  // MARK: email

  func testWithValidNonNONEEmail() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(email: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.email)
    XCTAssertEqual(result.email!, string)
  }

  func testWithValidNONEEmail() throws {
    let data = jsonData(email: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.email)
  }

  func testWithEmptyEmail() throws {
    let data = jsonData(email: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.email)
  }

  func testInvalidEmailType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(email: .present(element))
      assertTypeMismatch(from: data, "email")
    }

  }

  func testMissingEmail() throws {
    let data = jsonData(email: .absent)
    assertMissing(from: data, "email")
  }

  func testNullEmail() throws {
    let data = jsonData(email: .present(nil))
    assertNull(from: data, "email")
  }

  func testWithEmailPrefixSuffixWhitespaces() throws {
    var data = [" NONE", "NONE ", " NONE ", " ", "  "].map {
      jsonData(email: .present($0))
    }

    for data in data {
      let result = try toObject(from: data)
      XCTAssertNil(result.email)
    }

    data = [" xyz", "xyz  ", "  xyz "].map { jsonData(email: .present($0)) }
    for data in data {
      let result = try toObject(from: data)
      XCTAssertNotNil(result.email)
      XCTAssertEqual(result.email, "xyz")
    }

  }

  // MARK: value

  func testWithValidValue() throws {
    let string = String.randomAlphaNumericString(of: 5)
    let data = jsonData(value: .present(string))
    let result = try toObject(from: data)
    XCTAssertNotNil(result.value)
    XCTAssertEqual(result.value, string)
  }

  func testWithEmptyValue() throws {
    let data = jsonData(value: .present(""))
    dataCorrupted(from: data) { context in
      XCTAssertFalse(context.codingPath.isEmpty)
      XCTAssertEqual(context.codingPath[0].stringValue, "value")
      XCTAssertNil(context.underlyingError)
    }
  }

  func testInvalidValueType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(value: .present(element))
      assertTypeMismatch(from: data, "value")
    }

  }

  func testMissingValue() throws {
    let data = jsonData(value: .absent)
    assertMissing(from: data, "value")
  }

  func testNullValue() throws {
    let data = jsonData(value: .present(nil))
    assertNull(from: data, "value")
  }

  // MARK: url

  func testWithValidUrl() throws {
    let string = "https://google.com/"
    let data = jsonData(url: .present(string))
    let object = try toObject(from: data)
    XCTAssertNotNil(object.url)
    XCTAssertEqual(object.url!.description, string)
  }

  func testWithNONEUrl() throws {
    let data = jsonData(url: .present(String.none))
    let result = try toObject(from: data)
    XCTAssertNil(result.url)
  }

  func testWithEmptyURL() throws {
    let data = jsonData(url: .present(""))
    let result = try toObject(from: data)
    XCTAssertNil(result.url)
  }

  func testInvalidUrlType() throws {
    let list: [Any] = [
      Int.random(in: Int.min...Int.max),
      [],
      Float.random(in: 0.0..<10.0),
      Bool.random(),
      [:],
    ]
    for element in list {
      let data = jsonData(url: .present(element))
      assertTypeMismatch(from: data, "url")
    }

  }

  func testMissingUrl() throws {
    let data = jsonData(url: .absent)
    assertMissing(from: data, "url")
  }

  func testNullUrl() throws {
    let data = jsonData(url: .present(nil))
    assertNull(from: data, "url")
  }

}

final class EncodeUMLSCreatorContactTests: XCTestCase, EncoderTestsProtocol {

  typealias Object = UMLSCreatorContact<UMLSPostalAddress>
  typealias DataType = String
  typealias AssociatedKey = CreatorContactKey

  enum CreatorContactKey: CaseIterable {
    case handle, name, title, organization, telephone, fax, email, value
  }

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

  func initialize(forKey key: CreatorContactKey, value: String?) -> UMLSCreatorContact<
    UMLSPostalAddress
  > {
    switch key {
    case .handle:
      .randomInitializer(handle: value)
    case .name:
      .randomInitializer(name: value)
    case .title:
      .randomInitializer(title: value)
    case .organization:
      .randomInitializer(organization: value)
    case .telephone:
      .randomInitializer(telephone: value)
    case .fax:
      .randomInitializer(fax: value)
    case .email:
      .randomInitializer(email: value)
    case .value:
      .randomInitializer(value: value!)
    }
  }

  func value(forkey key: CreatorContactKey, from object: UMLSCreatorContact<UMLSPostalAddress>)
    -> String?
  {
    switch key {
    case .handle: object.handle
    case .name: object.name
    case .title: object.title
    case .organization: object.organization
    case .telephone: object.telephone
    case .fax: object.fax
    case .email: object.email
    case .value: object.value
    }
  }

  var nullEncodingStrings: [String?] = [
    nil,
    "",
    String.none,
    " ",
    "   ",
  ]

  func testValidString() throws {
    try CreatorContactKey.allCases.forEach { try assertEncoding(forKey: $0) }
  }

  func testNullEncoding() throws {
    try [.handle, .email, .fax, .name, .organization, .telephone, .title].forEach {
      try assertNull(forKey: $0)
    }
  }

  func testURL() throws {
    let object = UMLSCreatorContact<UMLSPostalAddress>.randomInitializer(url: nil)
    XCTAssertNoThrow(try self.toData(object))
  }

}
