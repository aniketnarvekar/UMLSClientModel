// Generator.swift

import Foundation
import UMLSClientModel
import WebURL

public protocol RandomGenerator {
  static func random<G: RandomNumberGenerator>(using generator: inout G) -> Self
}

extension RandomGenerator {

  static public func random() -> Self {
    var g = SystemRandomNumberGenerator()
    return random(using: &g)
  }

}

extension RandomGenerator where Self: CaseIterable {

  public static func random<G: RandomNumberGenerator>(using generator: inout G) -> Self {
    .allCases.randomElement(using: &generator)!
  }

}

extension UInt8 {

  public static let alphaNumericCharacterCodes: [UInt8] = [
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88,
    89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114,
    115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57,
  ]

  public static let numericCharacterCodes: [UInt8] = [
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57,
  ]

}

extension String {

  public static func randomBoolString() -> String {
    ["true", "false"].randomElement()!
  }

  public static func randomAlphaNumericString(of size: UInt) -> String {
    let array = (0..<size).map({ _ in
      Character(.init(UInt8.alphaNumericCharacterCodes.randomElement()!))
    })
    return String(array)
  }

  public static func randomStringWithNone() -> String {
    ["NONE", String.randomAlphaNumericString(of: 10)].randomElement()!
  }

  public static func randomNumericString(of size: UInt8) -> String {
    let array = (0...size).map({ _ in Character(.init(UInt8.numericCharacterCodes.randomElement()!))
    })
    return String(array)
  }

}

extension Date {

  public static func randomBetween(start: String, end: String, format: String = "MM-dd-yyyy")
    -> String
  {
    let date1 = Date.parse(start, format: format)
    let date2 = Date.parse(end, format: format)
    return Date.randomBetween(start: date1, end: date2).dateString(format)
  }

  public static func randomBetween(start: Date, end: Date) -> Date {
    var date1 = start
    var date2 = end
    if date2 < date1 {
      let temp = date1
      date1 = date2
      date2 = temp
    }
    let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
    return Date(timeIntervalSinceNow: span)
  }

  public func dateString(_ format: String = "MM-dd-yyyy") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }

  public static func parse(_ string: String, format: String = "MM-dd-yyyy") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.default
    dateFormatter.dateFormat = format

    let date = dateFormatter.date(from: string)!
    return date
  }

  public static func randomDateString(format: String = "MM-dd-yyy") -> String {
    randomDate().dateString(format)
  }

  public static func randomDate() -> Date {
    randomBetween(start: .distantPast, end: .now)
  }

}

extension UMLSLanguageName: RandomGenerator {}

extension UMLSContextType: RandomGenerator {}

extension UMLSLanguageInfo: RandomGenerator {

  public static func random<G>(using generator: inout G) -> UMLSClientModel.UMLSLanguageInfo
  where G: RandomNumberGenerator {
    .init(abbreviation: .random(using: &generator), name: .random(using: &generator))
  }

}

extension UMLSLanguageTypeObject: RandomGenerator where Self.Object: RandomGenerator {

  public static func random<G>(using generator: inout G) -> UMLSLanguageTypeObject<U>
  where G: RandomNumberGenerator {
    .init(object: .random(using: &generator))
  }

}

// MARK: - UMLSPostalAddress

// MARK: UMLSPostalAddress+RandomGenerator

extension UMLSPostalAddress: RandomGenerator {
  public static func random<G>(using generator: inout G) -> UMLSPostalAddress
  where G: RandomNumberGenerator {
    .init(
      address1: .randomAlphaNumericString(of: 10), address2: .randomAlphaNumericString(of: 10),
      city: .randomAlphaNumericString(of: 10), stateOrProvince: .randomAlphaNumericString(of: 10),
      country: .randomAlphaNumericString(of: 10), zipCode: .randomAlphaNumericString(of: 10))
  }
}

// MARK: UMLSPostalAddress+Extension

extension UMLSPostalAddress {

  public static func randomInitializer(
    address1: String? = .randomAlphaNumericString(of: 10),
    address2: String? = .randomAlphaNumericString(of: 10),
    city: String? = .randomAlphaNumericString(of: 10),
    stateOrProvince: String? = .randomAlphaNumericString(of: 10),
    country: String? = .randomAlphaNumericString(of: 10),
    zipCode: String? = .randomNumericString(of: 10)
  ) -> Self {
    .init(
      address1: address1, address2: address2, city: city, stateOrProvince: stateOrProvince,
      country: country, zipCode: zipCode)
  }

}

// MARK: - WebURL

extension WebURL: RandomGenerator {
  public static func random<G>(using generator: inout G) -> WebURL
  where G: RandomNumberGenerator {
    WebURL("https://github.com")!
  }

}

// MARK: - UMLSCreatorContact

// MARK: UMLSCreatorContact+RandomGenerator

extension UMLSCreatorContact: RandomGenerator where Address: RandomGenerator {

  public static func random<G>(using generator: inout G) -> UMLSCreatorContact<Address>
  where G: RandomNumberGenerator {
    .init(
      handle: .randomNumericString(of: 10), name: .randomAlphaNumericString(of: 10),
      title: .randomAlphaNumericString(of: 10), organization: .randomAlphaNumericString(of: 10),
      address: .random(using: &generator), telephone: .randomAlphaNumericString(of: 10),
      fax: .randomAlphaNumericString(of: 10), email: .randomAlphaNumericString(of: 10),
      url: .random(using: &generator),
      value: .randomAlphaNumericString(of: 10))
  }

  public static func randomInitializer(
    handle: String? = .randomAlphaNumericString(of: 10),
    name: String? = .randomAlphaNumericString(of: 10),
    title: String? = .randomAlphaNumericString(of: 10),
    organization: String? = .randomAlphaNumericString(of: 10),
    address: Address = .random(), telephone: String? = .randomAlphaNumericString(of: 10),
    fax: String? = .randomAlphaNumericString(of: 10),
    email: String? = .randomAlphaNumericString(of: 10),
    url: WebURL? = .random(), value: String = .randomAlphaNumericString(of: 10)
  ) -> Self {
    .init(
      handle: handle, name: name, title: title, organization: organization, address: address,
      telephone: telephone, fax: fax, email: email, url: url, value: value)
  }

}

extension UMLSLanguageAbbreviation: RandomGenerator {}

extension UMLSContactInformationTypeObject: RandomGenerator where Self.Object: RandomGenerator {

  public static func random<G>(using generator: inout G) -> UMLSContactInformationTypeObject<T>
  where G: RandomNumberGenerator {
    .init(object: .random(using: &generator))
  }

}

extension UMLSLicenseContact: RandomGenerator where Self.Address: RandomGenerator {

  public static func random<G>(using generator: inout G) -> UMLSLicenseContact<Address>
  where G: RandomNumberGenerator {
    .init(
      handle: .randomAlphaNumericString(of: 10), name: .randomAlphaNumericString(of: 10),
      title: .randomAlphaNumericString(of: 10), organization: .randomAlphaNumericString(of: 10),
      address: .random(using: &generator), telephone: .randomAlphaNumericString(of: 10),
      fax: .randomAlphaNumericString(of: 10), email: .randomAlphaNumericString(of: 10),
      url: .random(using: &generator), value: .randomAlphaNumericString(of: 10))
  }

  public static func randomInitializer(
    handle: String? = .randomAlphaNumericString(of: 10),
    name: String? = .randomAlphaNumericString(of: 10),
    title: String? = .randomAlphaNumericString(of: 10),
    organization: String? = .randomAlphaNumericString(of: 10),
    address: Address = .random(), telephone: String? = .randomAlphaNumericString(of: 10),
    fax: String? = .randomAlphaNumericString(of: 10),
    email: String? = .randomAlphaNumericString(of: 10),
    url: WebURL? = .random(), value: String = .randomAlphaNumericString(of: 10)
  ) -> Self {
    .init(
      handle: handle, name: name, title: title, organization: organization, address: address,
      telephone: telephone, fax: fax, email: email, url: url, value: value)
  }

}

extension UMLSSourceRestrictionLevel: RandomGenerator {}

extension UMLSSourceVocabularyInfo: RandomGenerator
where
  Self.Language: RandomGenerator, CreatorContact: RandomGenerator, LicenseContact: RandomGenerator
{

  public static func random<G>(using generator: inout G) -> UMLSSourceVocabularyInfo<
    Language, CreatorContact, LicenseContact
  > where G: RandomNumberGenerator {
    .init(
      abbreviation: .randomAlphaNumericString(of: 10),
      expandedForm: .randomAlphaNumericString(of: 10),
      family: .randomAlphaNumericString(of: 10), language: .random(using: &generator),
      restrictionLevel: .random(),
      acquisitionContact: .randomAlphaNumericString(of: 10),
      contentContact: .random(using: &generator), licenseContact: .random(using: &generator),
      contextType: .random(), shortName: .randomAlphaNumericString(of: 10),
      hierarchicalName: .randomAlphaNumericString(of: 10),
      preferredName: .randomAlphaNumericString(of: 10),
      synonymousNames: .randomAlphaNumericString(of: 10))
  }

  public static func randomInitializer(
    abbreviation: String = .randomAlphaNumericString(of: 10),
    expandedForm: String = .randomAlphaNumericString(of: 10),
    family: String = .randomAlphaNumericString(of: 10),
    language: UMLSLanguageTypeObject<Language> = .random(),
    restrictionLevel: UMLSSourceRestrictionLevel = .random(),
    acquisitionContact: String? = .randomAlphaNumericString(of: 10),
    contentContact: UMLSContactInformationTypeObject<CreatorContact> = .random(),
    licenseContact: UMLSContactInformationTypeObject<LicenseContact> = .random(),
    contextType: UMLSContextType = .random(),
    shortName: String = .randomAlphaNumericString(of: 10),
    hierarchicalName: String? = .randomAlphaNumericString(of: 10),
    preferredName: String = .randomAlphaNumericString(of: 10),
    synonymousNames: String? = .randomAlphaNumericString(of: 10)
  ) -> Self {
    .init(
      abbreviation: abbreviation, expandedForm: expandedForm, family: family, language: language,
      restrictionLevel: restrictionLevel, acquisitionContact: acquisitionContact,
      contentContact: contentContact, licenseContact: licenseContact, contextType: contextType,
      shortName: shortName, hierarchicalName: hierarchicalName, preferredName: preferredName,
      synonymousNames: synonymousNames)
  }

}

extension UMLSSourceVocabularyTypeObject: RandomGenerator where Object: RandomGenerator {

  public static func random<G>(using generator: inout G) -> UMLSSourceVocabularyTypeObject<Object>
  where G: RandomNumberGenerator {
    .init(object: .random(using: &generator))
  }

}
