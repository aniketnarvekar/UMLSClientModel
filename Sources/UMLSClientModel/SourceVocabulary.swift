// SourceVocabulary.swift

import Foundation
import WebURL

/// UMLS supported Languages.
public enum UMLSLanguageAbbreviation: String, Sendable {
  /// Arabic
  case ara = "ARA"
  /// Basque
  case baq = "BAQ"
  /// Chinese
  case chi = "CHI"
  /// Czech
  case cze = "CZE"
  /// Danish
  case dan = "DAN"
  /// Dutch
  case dut = "DUT"
  /// English
  case eng = "ENG"
  /// Estonian
  case est = "EST"
  /// Finnish
  case fin = "FIN"
  /// French
  case fre = "FRE"
  /// German
  case ger = "GER"
  /// Greek
  case gre = "GRE"
  /// Hebrew
  case heb = "HEB"
  /// Hungarian
  case hun = "HUN"
  /// Italian
  case ita = "ITA"
  /// Japanese
  case jpn = "JPN"
  /// Korean
  case kor = "KOR"
  /// Latvian
  case lav = "LAV"
  /// Norwegian
  case nor = "NOR"
  /// Polish
  case pol = "POL"
  /// Portuguese
  case por = "POR"
  /// Russian
  case rus = "RUS"
  /// Croatian
  case scr = "SCR"
  /// Spanish
  case spa = "SPA"
  /// Swedish
  case swe = "SWE"
  /// Turkish
  case tur = "TUR"
  /// Ukrainian
  case ukr = "UKR"

}

extension UMLSLanguageAbbreviation: CaseIterable {}

extension UMLSLanguageAbbreviation: Codable {}

// MARK: - Object type enumeration

public enum UMLSObject: String, Codable {
  case language = "Language"
  case contentInfo = "ContactInformation"
  case sourceVocabulary = "RootSource"
}

// MARK: - Object Type Specification

public protocol UMLSTypeDecodable: Decodable {
  associatedtype Object: Decodable
  var object: Object { get }
}

// MARK: - Language

// MARK: Specification

/// The UMLS Language specification.
public protocol UMLSLanguage {
  /// An language abbreviation.
  var abbreviation: UMLSLanguageAbbreviation { get }
  /// A human readable name of the language.
  var name: UMLSLanguageName { get }
}

// MARK: Implementation

public struct UMLSLanguageInfo: UMLSLanguage, Equatable {

  public var abbreviation: UMLSLanguageAbbreviation
  public var name: UMLSLanguageName

  public init(
    abbreviation: UMLSLanguageAbbreviation, name: UMLSLanguageName
  ) {
    self.abbreviation = abbreviation
    self.name = name
  }

}

extension UMLSLanguageInfo: Codable, Sendable {

  private enum CodingKeys: String, CodingKey {
    case abbreviation
    case name = "expandedForm"
  }

}

// MARK: - Language Object Type

// MARK: Specification

public protocol UMLSLanguageType: UMLSTypeDecodable
where Self.Object: UMLSLanguage {}

// MARK: Implementation

public struct UMLSLanguageTypeObject<U: UMLSLanguage & Decodable & Sendable>: UMLSLanguageType,
  Decodable, Sendable
{

  public var object: U

  private enum CodingKeys: CodingKey {
    case classType
  }

  public init(object: U) {
    self.object = object
  }

  public init(from decoder: any Decoder) throws {

    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(UMLSObject.self, forKey: .classType)
    guard type == .language else {
      throw
        DecodingError
        .dataCorruptedError(
          forKey: .classType, in: container,
          debugDescription: "Unsupported class type \(type.rawValue)")
    }

    let singleValueContainer = try decoder.singleValueContainer()
    self.object = try singleValueContainer.decode(U.self)
  }
}

// MARK: Encodable

extension UMLSLanguageTypeObject: Encodable where Self.Object: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(UMLSObject.language, forKey: .classType)

    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(self.object)
  }

}

extension UMLSLanguageTypeObject: Equatable where Self.Object: Equatable {}

// MARK: - Address

// MARK: Implementation

/// A protocol that defines the essential components of a postal address.
public protocol UMLSAddress {
  /// The primary address line, typically including the street name and number.
  var address1: String? { get }

  /// An optional secondary address line, such as an apartment or suite number.
  var address2: String? { get }

  /// The city or locality of the address.
  var city: String? { get }

  /// The state or province of the address.
  var stateOrProvince: String? { get }

  /// The country of the address.
  var country: String? { get }

  /// The postal or ZIP code of the address.
  var zipCode: String? { get }

}

// MARK: Specification

public struct UMLSPostalAddress: UMLSAddress, Codable, Sendable, Equatable {

  public var address1: String?
  public var address2: String?
  public var city: String?
  public var stateOrProvince: String?
  public var country: String?
  public var zipCode: String?

  private enum CodingKeys: CodingKey {
    case address1
    case address2
    case city
    case stateOrProvince
    case country
    case zipCode
  }

  public init(
    address1: String? = nil, address2: String? = nil, city: String? = nil,
    stateOrProvince: String? = nil, country: String? = nil, zipCode: String? = nil
  ) {
    self.address1 = address1
    self.address2 = address2
    self.city = city
    self.stateOrProvince = stateOrProvince
    self.country = country
    self.zipCode = zipCode
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.address1 = try container.decodeTrimmedStringOrNil(forKey: .address1)
    self.address2 = try container.decodeTrimmedStringOrNil(forKey: .address2)
    self.city = try container.decodeTrimmedStringOrNil(forKey: .city)
    self.stateOrProvince = try container.decodeTrimmedStringOrNil(forKey: .stateOrProvince)
    self.country = try container.decodeTrimmedStringOrNil(forKey: .country)
    self.zipCode = try container.decodeTrimmedStringOrNil(forKey: .zipCode)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.address1 ?? .none, forKey: .address1)
    try container.encode(self.address2 ?? .none, forKey: .address2)
    try container.encode(self.city ?? .none, forKey: .city)
    try container.encode(self.stateOrProvince ?? .none, forKey: .stateOrProvince)
    try container.encode(self.country ?? .none, forKey: .country)
    try container.encode(self.zipCode ?? .none, forKey: .zipCode)
  }

}

// MARK: - Contact Information

public protocol UMLSContactInformation {
  associatedtype Address: UMLSAddress
  var handle: String? { get }
  /// A name of the creator.
  var name: String? { get }
  /// A creator's research title.
  var title: String? { get }
  /// A name of the organization.
  var organization: String? { get }
  /// An address 1.
  var address: Address { get }
  /// A telephone number.
  var telephone: String? { get }
  /// A fax number.
  var fax: String? { get }
  /// An email address.
  var email: String? { get }
  /// A website address.
  var url: WebURL? { get }
  /// A string string in which respective values are extracted.
  var value: String { get }

  init(
    handle: String?, name: String?, title: String?, organization: String?,
    address: Address, telephone: String?, fax: String?, email: String?,
    url: WebURL?, value: String
  )
}

private enum UMLSContactInformationCodingKeys: CodingKey {
  case handle
  case name
  case title
  case organization
  case telephone
  case fax
  case email
  case url
  case value
}

extension UMLSContactInformation where Self.Address: Decodable, Self: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: UMLSContactInformationCodingKeys.self)
    let handle = try container.decodeTrimmedStringOrNil(forKey: .handle)
    let name = try container.decodeTrimmedStringOrNil(forKey: .name)
    let title = try container.decodeTrimmedStringOrNil(forKey: .title)
    let organization = try container.decodeTrimmedStringOrNil(forKey: .organization)
    let telephone = try container.decodeTrimmedStringOrNil(forKey: .telephone)
    let fax = try container.decodeTrimmedStringOrNil(forKey: .fax)
    let email = try container.decodeTrimmedStringOrNil(forKey: .email)
    let urlStringOrNull = try container.decodeTrimmedStringOrNil(forKey: .url)
    var url: WebURL?
    if let urlString = urlStringOrNull {
      url = WebURL(urlString)
    }
    let value = try container.decodeNonEmptyString(forKey: .value)

    let singleValueContainer = try decoder.singleValueContainer()
    let address = try singleValueContainer.decode(Address.self)

    self.init(
      handle: handle, name: name, title: title, organization: organization, address: address,
      telephone: telephone, fax: fax, email: email, url: url, value: value)

  }

}

// MARK: - Creator Contact Information

// MARK: Specification

public protocol UMLSCreatorContactInformation: UMLSContactInformation {}

// MARK: Implementation

// An object that encapsulates decoded creator contact information.
public struct UMLSCreatorContact<Address: UMLSAddress & Decodable & Sendable>:
  UMLSCreatorContactInformation,
  Decodable & Sendable
{

  public var handle: String?
  public var name: String?
  public var title: String?
  public var organization: String?
  public let address: Address
  public var telephone: String?
  public var fax: String?
  public var email: String?
  public var url: WebURL?
  public var value: String

  public init(
    handle: String? = nil, name: String? = nil, title: String? = nil, organization: String? = nil,
    address: Address, telephone: String? = nil, fax: String? = nil, email: String? = nil,
    url: WebURL? = nil, value: String
  ) {
    self.handle = handle
    self.name = name
    self.title = title
    self.organization = organization
    self.address = address
    self.telephone = telephone
    self.fax = fax
    self.email = email
    self.url = url
    self.value = value
  }

}

extension UMLSCreatorContact: Encodable where Self.Address: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: UMLSContactInformationCodingKeys.self)
    try container.encode(self.handle ?? .none, forKey: .handle)
    try container.encode(self.name ?? .none, forKey: .name)
    try container.encode(self.title ?? .none, forKey: .title)
    try container.encode(self.organization ?? .none, forKey: .organization)
    try container.encode(self.telephone ?? .none, forKey: .telephone)
    try container.encode(self.fax ?? .none, forKey: .fax)
    try container.encode(self.email ?? .none, forKey: .email)
    try container.encode(self.url ?? .none, forKey: .url)
    try container.encode(self.value, forKey: .value)

    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(self.address)

  }

}

extension UMLSCreatorContact: Equatable where Self.Address: Equatable {}

// MARK: - Contact Information Type Object

public protocol UMLSContactInformationType {
  associatedtype Object: UMLSContactInformation
  var object: Object { get }
}

public struct UMLSContactInformationTypeObject<
  T: UMLSContactInformation & Decodable & Sendable
>: UMLSContactInformationType, Decodable, Sendable {

  public let object: T

  private enum CodingKeys: CodingKey {
    case classType
  }

  public init(object: T) {
    self.object = object
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let classTypeString = try container.decodeNonEmptyString(forKey: .classType)
    guard let classType = UMLSObject(rawValue: classTypeString) else {
      throw DecodingError.dataCorruptedError(
        forKey: .classType, in: container, debugDescription: "Invalid class type")
    }
    guard classType == .contentInfo else {
      throw DecodingError.dataCorruptedError(
        forKey: .classType, in: container, debugDescription: "Unsupported class type")
    }

    let singleValueContainer = try decoder.singleValueContainer()
    self.object = try singleValueContainer.decode(T.self)

  }

}

extension UMLSContactInformationTypeObject: Encodable where T: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(UMLSObject.contentInfo, forKey: .classType)

    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(self.object)

  }

}

extension UMLSContactInformationTypeObject: Equatable where Self.Object: Equatable {}

// MARK: - License Contact Information

// MARK: Specification

public protocol UMLSLicenseContactInformation: UMLSContactInformation {}

// MARK: Implementation

public struct UMLSLicenseContact<Address: UMLSAddress & Decodable & Sendable>:
  UMLSLicenseContactInformation,
  Decodable, Sendable
{

  public var handle: String?
  public var name: String?
  public var title: String?
  public var organization: String?
  public var address: Address
  public var telephone: String?
  public var fax: String?
  public var email: String?
  public var url: WebURL?
  public var value: String

  public init(
    handle: String? = nil, name: String? = nil, title: String? = nil, organization: String? = nil,
    address: Address, telephone: String? = nil, fax: String? = nil, email: String? = nil,
    url: WebURL? = nil, value: String
  ) {
    self.handle = handle
    self.name = name
    self.title = title
    self.organization = organization
    self.address = address
    self.telephone = telephone
    self.fax = fax
    self.email = email
    self.url = url
    self.value = value
  }

}

extension UMLSLicenseContact: Encodable where Address: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: UMLSContactInformationCodingKeys.self)
    try container.encode(self.handle ?? .none, forKey: .handle)
    try container.encode(self.name ?? .none, forKey: .name)
    try container.encode(self.title ?? .none, forKey: .title)
    try container.encode(self.organization ?? .none, forKey: .organization)
    try container.encode(self.telephone ?? .none, forKey: .telephone)
    try container.encode(self.fax ?? .none, forKey: .fax)
    try container.encode(self.email ?? .none, forKey: .email)
    try container.encode(self.url ?? .none, forKey: .url)
    try container.encode(self.value, forKey: .value)

    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(self.address)

  }

}

extension UMLSLicenseContact: Equatable where Address: Equatable {}

// MARK: - Source Restriction Level

public enum UMLSSourceRestrictionLevel: UInt8, Codable, CaseIterable, Sendable {
  case category0 = 0
  case category1 = 1
  case category2 = 2
  case category3 = 3
  case category4 = 4
  case category9 = 9
}

// MARK: - Source Vocabulary

public protocol UMLSSourceVocabularyInformation: Decodable {
  associatedtype Language: UMLSLanguageType
  associatedtype CreatorContactType: UMLSContactInformationType
  where CreatorContactType.Object: UMLSCreatorContactInformation
  associatedtype LicenseContactType: UMLSContactInformationType
  where LicenseContactType.Object: UMLSLicenseContactInformation
  var abbreviation: String { get }
  var expandedForm: String { get }
  var family: String { get }
  var language: Language { get }
  var restrictionLevel: UMLSSourceRestrictionLevel { get }
  var acquisitionContact: String? { get }
  var contentContact: CreatorContactType { get }
  var licenseContact: LicenseContactType { get }
  var contextType: UMLSContextType { get }
  var shortName: String { get }
  var hierarchicalName: String? { get }
  var preferredName: String { get }
  var synonymousNames: String? { get }
}

// MARK: Implementation

public struct UMLSSourceVocabularyInfo<
  Language: UMLSLanguage & Decodable & Sendable,
  CreatorContact: UMLSCreatorContactInformation & Decodable & Sendable,
  LicenseContact: UMLSLicenseContactInformation & Decodable & Sendable
>: UMLSSourceVocabularyInformation, Decodable, Sendable {
  public var abbreviation: String
  public var expandedForm: String
  public var family: String
  public var language: UMLSLanguageTypeObject<Language>
  public var restrictionLevel: UMLSSourceRestrictionLevel
  public var acquisitionContact: String?
  public var contentContact: UMLSContactInformationTypeObject<CreatorContact>
  public var licenseContact: UMLSContactInformationTypeObject<LicenseContact>
  public var contextType: UMLSContextType
  public var shortName: String
  public var hierarchicalName: String?
  public var preferredName: String
  public var synonymousNames: String?

  private enum CodingKeys: CodingKey {
    case abbreviation
    case expandedForm
    case family
    case language
    case restrictionLevel
    case acquisitionContact
    case contentContact
    case licenseContact
    case contextType
    case shortName
    case hierarchicalName
    case preferredName
    case synonymousNames
  }

  public init(
    abbreviation: String, expandedForm: String, family: String,
    language: UMLSLanguageTypeObject<Language>, restrictionLevel: UMLSSourceRestrictionLevel,
    acquisitionContact: String? = nil,
    contentContact: UMLSContactInformationTypeObject<CreatorContact>,
    licenseContact: UMLSContactInformationTypeObject<LicenseContact>,
    contextType: UMLSContextType, shortName: String, hierarchicalName: String? = nil,
    preferredName: String, synonymousNames: String? = nil
  ) {
    self.abbreviation = abbreviation
    self.expandedForm = expandedForm
    self.family = family
    self.language = language
    self.restrictionLevel = restrictionLevel
    self.acquisitionContact = acquisitionContact
    self.contentContact = contentContact
    self.licenseContact = licenseContact
    self.contextType = contextType
    self.shortName = shortName
    self.hierarchicalName = hierarchicalName
    self.preferredName = preferredName
    self.synonymousNames = synonymousNames
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.abbreviation = try container.decodeNonNoneAndEmptyString(forKey: .abbreviation)
    self.expandedForm = try container.decodeNonNoneAndEmptyString(forKey: .expandedForm)
    self.family = try container.decodeNonNoneAndEmptyString(forKey: .family)
    self.language = try container.decode(UMLSLanguageTypeObject<Language>.self, forKey: .language)
    self.restrictionLevel = try container.decode(
      UMLSSourceRestrictionLevel.self, forKey: .restrictionLevel)
    self.acquisitionContact = try container.decodeTrimmedStringOrNil(forKey: .acquisitionContact)
    self.contentContact = try container.decode(
      UMLSContactInformationTypeObject<CreatorContact>.self, forKey: .contentContact)
    self.licenseContact = try container.decode(
      UMLSContactInformationTypeObject<LicenseContact>.self, forKey: .licenseContact)

    let contextTypeString = try container.decode(String.self, forKey: .contextType)
      .trimmingCharacters(in: .whitespacesAndNewlines)
    guard let contextType = UMLSContextType(rawValue: contextTypeString) else {
      throw DecodingError.dataCorruptedError(
        forKey: .contextType, in: container,
        debugDescription: "Unsupported contextType \(contextTypeString)")
    }
    self.contextType = contextType

    self.shortName = try container.decodeNonNoneAndEmptyString(forKey: .shortName)
    self.hierarchicalName = try container.decodeTrimmedStringOrNil(forKey: .hierarchicalName)

    self.preferredName = try container.decodeNonNoneAndEmptyString(forKey: .preferredName)
    self.synonymousNames = try container.decodeNoneString(forKey: .synonymousNames)?
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }

}

extension UMLSSourceVocabularyInfo: Encodable
where Language: Encodable, CreatorContact: Encodable, LicenseContact: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.abbreviation, forKey: .abbreviation)
    try container.encode(self.expandedForm, forKey: .expandedForm)
    try container.encode(self.family, forKey: .family)
    try container.encode(self.language, forKey: .language)
    try container.encode(self.restrictionLevel, forKey: .restrictionLevel)
    var trimmedAcqusitionContact = (self.acquisitionContact ?? .none).trimmingCharacters(
      in: .whitespacesAndNewlines)
    trimmedAcqusitionContact =
      !trimmedAcqusitionContact.isEmpty ? trimmedAcqusitionContact : .none
    try container.encode(trimmedAcqusitionContact, forKey: .acquisitionContact)
    try container.encode(self.contentContact, forKey: .contentContact)
    try container.encode(self.licenseContact, forKey: .licenseContact)
    try container.encode(self.contextType, forKey: .contextType)
    try container.encode(self.shortName, forKey: .shortName)
    var trimmedHierarchicalName = (self.hierarchicalName ?? .none).trimmingCharacters(
      in: .whitespacesAndNewlines)
    trimmedHierarchicalName = !trimmedHierarchicalName.isEmpty ? trimmedHierarchicalName : .none
    try container.encode(trimmedHierarchicalName, forKey: .hierarchicalName)
    try container.encode(self.preferredName, forKey: .preferredName)
    var trimmedSynonymousNames = (self.synonymousNames ?? .none).trimmingCharacters(
      in: .whitespacesAndNewlines)
    trimmedSynonymousNames = !trimmedSynonymousNames.isEmpty ? trimmedSynonymousNames : .none
    try container.encode(trimmedSynonymousNames, forKey: .synonymousNames)
  }

}

extension UMLSSourceVocabularyInfo: Equatable
where Language: Equatable, CreatorContact: Equatable, LicenseContact: Equatable {}

// MARK: - Source vocabulary type

public protocol UMLSSourceVocabularyType: UMLSTypeDecodable, Decodable
where Self.Object: UMLSSourceVocabularyInformation {}

// MARK: Implementation

public struct UMLSSourceVocabularyTypeObject<
  Object: UMLSSourceVocabularyInformation & Decodable & Sendable
>: UMLSSourceVocabularyType, Sendable {
  public var object: Object

  private enum CodingKeys: CodingKey {
    case classType
  }

  public init(object: Object) {
    self.object = object
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let classType = try container.decode(UMLSObject.self, forKey: .classType)
    guard classType == .sourceVocabulary else {
      throw DecodingError.dataCorruptedError(
        forKey: .classType, in: container, debugDescription: "Unsupported class type.")
    }

    let singleValueContainer = try decoder.singleValueContainer()
    self.object = try singleValueContainer.decode(Object.self)
  }
}

extension UMLSSourceVocabularyTypeObject: Encodable where Object: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(UMLSObject.sourceVocabulary, forKey: .classType)

    var singleValueContainer = encoder.singleValueContainer()
    try singleValueContainer.encode(self.object)

  }

}
