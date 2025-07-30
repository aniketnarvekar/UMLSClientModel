// UMLSUIType.swift

import Foundation

public protocol UMLSUIType {
  init(string: String)
  var string: String { get }
  var isValid: Bool { get }
}

extension UMLSUIType where Self: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.string)
  }

}

public struct UMLSAtom: UMLSUIType, Equatable, Sendable {

  public var string: String

  public var isValid: Bool {
    let objects = self.string.matches(of: /^A\d{7,8}$/)
    return objects.count == 1
  }

  public init(string: String) {
    self.string = string
  }

}

extension UMLSAtom: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.string = try container.decode(String.self)
  }

}

extension UMLSAtom: Encodable {}

public struct UMLSConcept: UMLSUIType, Equatable, Sendable {

  public var string: String
  public var isValid: Bool {
    let objects = self.string.matches(of: /^C\d{7}$/)
    return objects.count == 1
  }

  public init(string: String) {
    self.string = string
  }

}

extension UMLSConcept: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.string = try container.decode(String.self)
  }

}

extension UMLSConcept: Encodable {}

public struct UMLSRelation: UMLSUIType, Equatable, Sendable {

  public var string: String

  public var isValid: Bool {
    !self.string.matches(of: /^R\d{9}$/).isEmpty
  }

  public init(string: String) {
    self.string = string
  }

}

extension UMLSRelation: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.string = try container.decode(String.self)
  }

}

extension UMLSRelation: Encodable {}

public struct UMLSTUI: UMLSUIType, Equatable, Sendable {

  public var string: String
  public var isValid: Bool {
    let objects = self.string.matches(of: /^T\d{3}$/)
    return objects.count == 1
  }

  public init(string: String) {
    self.string = string
  }

}

extension UMLSTUI: Decodable {

  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.string = try container.decode(String.self)
  }

}

extension UMLSTUI: Encodable {}
