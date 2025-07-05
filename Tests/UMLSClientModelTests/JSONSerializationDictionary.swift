// JSONSerializationDictionary.swift

import Foundation
import Random
import UMLSClientModel
import XCTest

// MARK: - Decoding Error assertion

protocol XCTDecodingErrorAssertion {

  associatedtype Element

  var jsonDecoder: JSONDecoder! { get set }
  var jsonEncoder: JSONEncoder! { get set }

}

extension XCTDecodingErrorAssertion where Element: Decodable {

  func toObject(from data: Data) throws -> Element {
    try jsonDecoder.decode(Element.self, from: data)
  }

  func errorBlock(from data: Data, completion: (Error) -> Void) {
    XCTAssertThrowsError(try toObject(from: data)) { error in
      completion(error)
    }
  }

  func dataCorrupted(from data: Data, completion: (DecodingError.Context) -> Void) {
    errorBlock(from: data) { error in
      guard case DecodingError.dataCorrupted(let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(context)
    }
  }

  func keyNotFound(
    from data: Data,
    completion: (CodingKey, DecodingError.Context) -> Void
  ) {
    errorBlock(from: data) { error in
      guard case DecodingError.keyNotFound(let key, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(key, context)
    }
  }

  func typeMismatch(from data: Data, completion: (Any, DecodingError.Context) -> Void) {
    errorBlock(from: data) { error in
      guard case DecodingError.typeMismatch(let any, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(any, context)
    }
  }

  func valueNotFound(from data: Data, completion: (Any.Type, DecodingError.Context) -> Void) {
    errorBlock(from: data) { error in
      guard case DecodingError.valueNotFound(let type, let context) = error else {
        return XCTFail("Unexpected error: \(error)")
      }
      completion(type, context)
    }
  }

}

extension XCTDecodingErrorAssertion {

  func toData<T: Encodable>(from object: T) throws -> Data {
    try jsonEncoder.encode(object)
  }

}

extension XCTDecodingErrorAssertion where Element: Encodable & CaseIterable {

  func data() throws -> [Data] {
    try Element.allCases.map { try toData(from: $0) }
  }

}

// MARK: - JSON Value

enum JSONValue<T> {
  case present(_ value: T?)
  case absent
}

func toJSON(dictionary: [String: JSONValue<Any>]) -> Data {
  var dict: [String: Any] = .init()
  for (key, value) in dictionary {
    if case JSONValue<Any>.present(let value) = value {
      dict[key] = value != nil ? value! : NSNull()
    }
  }
  return try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys])
}

// MARK: - Serialization dictionary

enum JSONSerializationDictionary {

  private static func dictionary(_ dictionary: [String: JSONValue<Any>]) -> [String: Any] {
    var dict: [String: Any] = .init()
    for (key, value) in dictionary {
      if case JSONValue<Any>.present(let value) = value {
        dict[key] = value != nil ? value! : NSNull()
      }
    }
    return dict
  }

  static func languageInfo(
    classType: JSONValue<Any> = .present(UMLSObject.language.rawValue),
    abbreviation: JSONValue<Any> = .present(UMLSLanguageAbbreviation.random().rawValue),
    name: JSONValue<Any> = .present(UMLSLanguageName.random().rawValue)
  ) -> [String: Any] {
    dictionary([
      "classType": classType,
      "abbreviation": abbreviation,
      "expandedForm": name,
    ])
  }

  static func address(
    address1: JSONValue<Any> = .present(String.randomStringWithNone()),
    address2: JSONValue<Any> = .present(String.randomStringWithNone()),
    city: JSONValue<Any> = .present(String.randomStringWithNone()),
    stateOrProvince: JSONValue<Any> = .present(String.randomStringWithNone()),
    country: JSONValue<Any> = .present(String.randomStringWithNone()),
    zipCode: JSONValue<Any> = .present(String.randomStringWithNone())
  ) -> [String: Any] {
    dictionary([
      "address1": address1,
      "address2": address2,
      "city": city,
      "stateOrProvince": stateOrProvince,
      "country": country,
      "zipCode": zipCode,
    ])
  }

  static func creatorContact(
    classType: JSONValue<Any> = .present("ContactInformation"),
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
    url: JSONValue<Any> = .present("https://localhost:8080/"),
    value: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10))
  ) -> [String: Any] {
    dictionary([
      "classType": classType,
      "handle": handle,
      "name": name,
      "title": title,
      "organization": organization,
      "address1": address1,
      "address2": address2,
      "city": city,
      "stateOrProvince": stateOrProvince,
      "country": country,
      "zipCode": zipCode,
      "telephone": telephone,
      "fax": fax,
      "email": email,
      "url": url,
      "value": value,
    ])
  }

  static func sourceVocabulary(
    classType: JSONValue<Any> = .present("RootSource"),
    abbreviation: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    expanededForm: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    family: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    language: JSONValue<Any> = .present(languageInfo()),
    restrictionLevel: JSONValue<Any> = .present(UInt.random(in: 0..<10)),
    acquisitionContact: JSONValue<Any> = .present(
      ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!),
    contentContact: JSONValue<Any> = .present(creatorContact()),
    licenseContact: JSONValue<Any> = .present(creatorContact()),
    contextType: JSONValue<Any> = .present(UMLSContextType.random().rawValue),
    shortName: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    hierarchicalName: JSONValue<Any> = .present(
      ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!),
    preferredName: JSONValue<Any> = .present(String.randomAlphaNumericString(of: 10)),
    synonymousNames: JSONValue<Any> = .present(
      ["NONE", .randomAlphaNumericString(of: 10)].randomElement()!)
  ) -> [String: Any] {
    dictionary([
      "classType": classType,
      "abbreviation": abbreviation,
      "expandedForm": expanededForm,
      "family": family,
      "language": language,
      "restrictionLevel": restrictionLevel,
      "acquisitionContact": acquisitionContact,
      "contentContact": contentContact,
      "licenseContact": licenseContact,
      "contextType": contextType,
      "shortName": shortName,
      "hierarchicalName": hierarchicalName,
      "preferredName": preferredName,
      "synonymousNames": synonymousNames,
    ])
  }

}
