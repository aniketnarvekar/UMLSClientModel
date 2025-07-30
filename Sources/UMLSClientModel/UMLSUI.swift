// UMLSUI.swift

import Foundation

// MARK: - UI Error

/// UMLS unique identifier string validation error.
public enum UMLSUIStringError: Error {
  case invalidFormat
}

// MARK: Localized Error

extension UMLSUIStringError: LocalizedError {

  public var errorDescription: String? {
    switch self {
    case .invalidFormat:
      "Invalid UMLS Unique Identifier."
    }
  }

}

// MARK: - UMLS UI Definition.

/// UMLS unique identifier.
public struct UMLSUI<U: UMLSUIType> {
  fileprivate let object: U

  /// Initialise with formatted unique identifier string
  /// - Parameter string: Formatted unique identifier.
  /// - throws: Raise ``UMLSUIStringError`` for ill formatted string.
  public init(string: String) throws {
    let object = U(string: string)
    try self.init(object: object)
  }

  public init(object: U) throws {
    guard object.isValid else {
      throw UMLSUIStringError.invalidFormat
    }
    self.object = object
  }

}

// MARK: Custom String Convertable

extension UMLSUI: CustomStringConvertible {

  public var description: String {
    self.object.string
  }

}

// MARK: Sendable

extension UMLSUI: Sendable where U: Sendable {}

// MARK: Equatable

extension UMLSUI: Equatable where U: Equatable {}

// MARK: JSON Decodable

extension UMLSUI: Decodable where U: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let object = try container.decode(U.self)
    guard object.isValid else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: UMLSUIStringError.invalidFormat.localizedDescription)
    }
    self.object = object
  }

}

// MARK: JSON Encodable

extension UMLSUI: Encodable where U: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.object)
  }

}
