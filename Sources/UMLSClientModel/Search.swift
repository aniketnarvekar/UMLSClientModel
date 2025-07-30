// Search.swift

import Foundation

// MARK: - Search Page

/// A search page.
public struct UMLSSearchPage: Decodable, Equatable {

  /// The number of elements per page.
  public let size: Int
  /// The current page number.
  public let number: Int
  /// The total number of page available.
  public let count: Int
  /// The list of elements on current page.
  public let elements: [UMLSSearchElement]

  private var totalSize: Int

  private enum CodingKeys: CodingKey {
    case result
    case results
    case pageSize
    case pageNumber
    case recCount
  }

  static func numberOfPages(totalSize: Int, pageSize: Int) -> Int {
    var count = totalSize / pageSize
    count += totalSize % pageSize > 0 ? 1 : 0
    return count
  }

  public init(size: Int, number: Int, totalSize: Int, elements: [UMLSSearchElement]) {
    self.size = size
    self.number = number
    self.totalSize = totalSize
    self.count = UMLSSearchPage.numberOfPages(totalSize: totalSize, pageSize: size)
    self.elements = elements
  }

  /// Initializes a new instance of `UMLSPage` by decoding from the given decoder.
  /// - Parameter decoder: The decoder to read data from.
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.size = try container.decode(Int.self, forKey: .pageSize)
    self.number = try container.decode(Int.self, forKey: .pageNumber)
    let resultContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
    self.elements = try resultContainer.decode([UMLSSearchElement].self, forKey: .results)
    self.totalSize = try resultContainer.decode(Int.self, forKey: .recCount)
    self.count = UMLSSearchPage.numberOfPages(totalSize: totalSize, pageSize: size)
  }

  public static func == (lhs: UMLSSearchPage, rhs: UMLSSearchPage) -> Bool {
    return lhs.size == rhs.size && lhs.number == rhs.number && lhs.count == rhs.count
      && lhs.elements.allSatisfy { rhs.elements.contains($0) } && lhs.totalSize == rhs.totalSize
  }

}

// MARK: Encodable

extension UMLSSearchPage: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.size, forKey: .pageSize)
    try container.encode(self.number, forKey: .pageNumber)
    var resultContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
    try resultContainer.encode(self.elements, forKey: .results)
    try resultContainer.encode(self.totalSize, forKey: .recCount)
  }

}

// MARK: - Search Element

public struct UMLSSearchElement: Decodable, Equatable {

  public let id: String
  public let source: String
  public let name: String

  private enum CodingKeys: String, CodingKey {
    case id = "ui"
    case source = "rootSource"
    case name
  }

  public init(id: String, source: String, name: String) {
    self.id = id
    self.source = source
    self.name = name
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.source = try container.decode(String.self, forKey: .source)
    self.name = try container.decode(String.self, forKey: .name)
  }

}

// MARK: Encodable

extension UMLSSearchElement: Encodable {

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.name, forKey: .name)
    try container.encode(self.source, forKey: .source)
  }

}

/// The search input types.
///
/// Use `sourceUI` if you aren’t sure if the identifier you’re providing is a code, source concept, or source descriptor.
///
/// Using `tty` is for advanced use cases and will extract codes from a specified vocabulary according to [term type](https://www.nlm.nih.gov/research/umls/knowledge_sources/metathesaurus/release/precedence_suppressibility.html?_gl=1*18rbq7j*_ga*MTI2NDM5OTAzMS4xNzI4OTc4NTAy*_ga_7147EPK006*MTczNjUwNTM1Ni4zOS4xLjE3MzY1MDY0MDUuMC4wLjA.*_ga_P1FPTH9PL4*MTczNjUwNTM1Ni4zOS4xLjE3MzY1MDY0MDUuMC4wLjA.).
public enum UMLSSearchInputType: String {
  case atom = "atom"
  case code = "code"
  case sourceConcept = "sourceConept"
  case sourceDescriptor = "sourceDescriptor"
  case sourceUI = "sourceUi"
  case tty = "tty"
}

/// The search result identifier type.
///
/// Use `code`,`sourceConcept`, `sourceDescriptor`, or `sourceUi` if you prefer source-asserted identifiers rather than CUIs in your search results.
public enum UMLSSearchReturnIDType: String {
  case aui = "aui"
  case concept = "concept"
  case code = "code"
  case sourceConcept = "sourceConcept"
  case sourceDescriptor = "sourceDescriptor"
  case sourceUI = "sourceUi"
}

/// The type of search.
public enum UMLSSearchType: String {
  /// Retrieves only concepts that include a synonym that exactly matches the search term.
  case exact = "exact"
  /// Retrieves results where all words in the query appear in a particular name.
  case words = "words"
  /// Retrieves concepts with synonyms that end with the letters of the search term. For example, a left truncation search for “itis” retrieves concepts that contain synonyms such as colitis, bronchitis, pancreatitis.
  case leftTruncation = "leftTruncation"
  /// Retrieves concepts with synonyms that begin with the letters of the search term. For example, a right truncation search for “bronch” retrieves concepts that contain synonyms such as bronchitis, bronchiole, bronchial artery.
  case rightTruncation = "rightTruncation"
  /// Removes lexical variations such as plural and upper case text and compares search terms to the Metathesaurus normalized string index to retrieve relevant concepts.
  case normalizedString = "normalizedString"
  /// Removes lexical variations such as plural and upper case text, and compares search terms to the Metathesaurus normalized word index to retrieve relevant concepts.
  case normalizedWords = "normalizedWords"
}

/// The search parameters for UMLS Search API.
///
/// The protocol defines possible search parameters.
public protocol UMLSSearchParameters {
  /// The search string.
  var string: String { get }
  /// The search input type.
  var inputType: UMLSSearchInputType { get }
  /// Whether to include Obsolete terms or not.
  var includeObsolete: Bool { get }
  /// Whether to include suppressible terms or not.
  var includeSuppressible: Bool { get }
  /// The return identiifer type.
  var returnIdType: UMLSSearchReturnIDType { get }
  /// The list of UMLS source vocabularies.
  var sourceVocabularies: [UMLSSourceVocabulary] { get }
  /// The search type.
  var searchType: UMLSSearchType { get }
  /// Whether th search is partical or not.
  var partialSearch: Bool { get }
  /// The page number.
  var pageNumber: Int { get }
  /// The page size for given `pageNumber`
  var pageSize: Int { get }
}

private struct __UMLSSearchParameters: UMLSSearchParameters {
  var string: String
  var inputType: UMLSSearchInputType
  var includeObsolete: Bool
  var includeSuppressible: Bool
  var returnIdType: UMLSSearchReturnIDType
  var sourceVocabularies: [UMLSSourceVocabulary]
  var searchType: UMLSSearchType
  var partialSearch: Bool
  var pageNumber: Int
  var pageSize: Int

  fileprivate init(
    string: String,
    inputType: UMLSSearchInputType,
    includeObsolete: Bool,
    includeSuppressible: Bool,
    returnIdType: UMLSSearchReturnIDType,
    sourceVocabularies: [UMLSSourceVocabulary],
    searchType: UMLSSearchType,
    partialSearch: Bool,
    pageNumber: Int,
    pageSize: Int
  ) {
    self.string = string
    self.inputType = inputType
    self.includeObsolete = includeObsolete
    self.includeSuppressible = includeSuppressible
    self.returnIdType = returnIdType
    self.sourceVocabularies = sourceVocabularies
    self.searchType = searchType
    self.partialSearch = partialSearch
    self.pageNumber = pageNumber
    self.pageSize = pageSize
  }

}

/// The `UMLSSearchParameters` builder.
public class UMLSSearchParametersBuilder {

  private var string: String
  private var inputType: UMLSSearchInputType?
  private var includeAbsolute: Bool?
  private var includeSuppressible: Bool?
  private var returnIdType: UMLSSearchReturnIDType?
  private var sourceVocabularies: [UMLSSourceVocabulary] = []
  private var searchType: UMLSSearchType?
  private var partialSearch: Bool?
  private var pageNumber: Int?
  private var pageSize: Int?

  /// The search parameter build error.
  public enum BuildError: Error, Equatable {
    case emptySearchString
    case invalidPageSize(number: Int)
    case invalidPageNumber(number: Int)
  }

  /// Initialize `UMLSSearchParametersBuilder` object.
  ///
  /// - Parameter string: A search string.
  /// - Throws: Raise `BuildErorr.emptySearchString` if the string is empty.
  public init(_ string: String) throws {
    guard !string.isEmpty else {
      throw BuildError.emptySearchString
    }
    self.string = string
  }

  /// Sets a new search string.
  /// - Parameter string: a search string
  /// - Returns: Returns reference to `Self`.
  /// - Throws: Raise `BuildErorr.emptySearchString` if the string is empty.
  public func setSearchText(_ string: String) throws -> Self {
    guard !string.isEmpty else {
      throw BuildError.emptySearchString
    }
    self.string = string
    return self
  }

  /// Sets input type.
  /// - Parameter inputType: search input type.
  /// - Returns: Returns reference to `Self`.
  public func setInputType(_ inputType: UMLSSearchInputType) -> Self {
    self.inputType = inputType
    return self
  }

  /// Set whether search include obsolete or not.
  /// - Parameter bool: `true` for include obsolete else `false`.
  /// - Returns: Returns reference to `Self`.
  public func setIncludeObsolete(_ bool: Bool) -> Self {
    self.includeAbsolute = bool
    return self
  }

  /// Set whether search include suppressible terms.
  /// - Parameter bool: `true` for include suppressible else `false`.
  /// - Returns: Returns reference to `Self`.
  public func setIncludeSuppressible(_ bool: Bool) -> Self {
    self.includeSuppressible = bool
    return self
  }

  /// Add source vocabulary.
  ///
  ///If source vocabulary already present then skip.
  ///
  /// The string should be UMLS asserted [source vocabulary](https://www.nlm.nih.gov/research/umls/sourcereleasedocs/) abbreviation.
  /// - Parameter string:
  /// - Returns: Returns reference to `Self`.
  public func addSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) throws -> Self {
    // TODO: User source vocabulary as swift object for compile time validation of the source vocabulary.
    if !self.sourceVocabularies.contains(sourceVocabulary) {
      self.sourceVocabularies.append(sourceVocabulary)
    }
    return self
  }

  /// Remove source vocabulary if present.
  ///
  /// - Parameter sourceVocabulary: A source vocabulary.
  /// - Returns: Returns reference to `Self`.
  public func removeSourceVocabulary(_ sourceVocabulary: UMLSSourceVocabulary) -> Self {
    if let index = self.sourceVocabularies.firstIndex(of: sourceVocabulary) {
      self.sourceVocabularies.remove(at: index)
    }
    return self
  }

  /// Set search type.
  /// - Parameter searchType: Search type.
  /// - Returns: Returns reference to `Self`.
  public func setSearchType(_ searchType: UMLSSearchType) -> Self {
    self.searchType = searchType
    return self
  }

  /// Set whether search is partial search.
  /// - Parameter bool: `true` if partial else `false`.
  /// - Returns: Returns reference to `Self`.
  public func setPartialSearch(_ bool: Bool) -> Self {
    self.partialSearch = bool
    return self
  }

  /// Set page size.
  ///
  /// The page size should be > 0.
  /// - Parameter number: The page number.
  /// - Returns: Returns reference to `Self`.
  /// - Throws: Raise `BuildErorr.invalidPageSize(number:)` if number <= 0.
  public func setPageSize(_ number: Int) throws -> Self {
    guard number > 0 else {
      throw BuildError.invalidPageSize(number: number)
    }
    self.pageSize = number
    return self
  }

  /// Set page number.
  ///
  /// The page number should be > 0.
  /// - Parameter number: The page size.
  /// - Returns:Returns reference to `Self`.
  /// - Throws: Raise `BuildErorr.invalidPageNumber(number:)` if number <= 0.
  public func setPageNumber(_ number: Int) throws -> Self {
    guard number > 0 else {
      throw BuildError.invalidPageNumber(number: number)
    }
    self.pageNumber = number
    return self
  }

  /// Create and return object that implements `UMLSSearchParameters`.
  ///
  /// The function sets the following default parameters if not specified:
  /// - intputType: `UMLSSearchType.Atom`
  /// - includeObsolete: `false`
  /// - includeSuppressible: `false`
  /// - returnIdType: `UMLSSearchReturnIDType.Concept`
  /// - sourceVocabularies: `[]`
  /// - searchType: `UMLSSearchType.Words`
  /// - partialSearch: `false`
  /// - pageNumber: `1`
  /// - pageSize: `25`
  /// - Returns: Returns object that implements ``UMLSSearchParameters``.
  public func build() -> UMLSSearchParameters {
    __UMLSSearchParameters(
      string: self.string,
      inputType: self.inputType ?? .atom,
      includeObsolete: includeAbsolute ?? false,
      includeSuppressible: includeSuppressible ?? false,
      returnIdType: returnIdType ?? .concept,
      sourceVocabularies: self.sourceVocabularies,
      searchType: self.searchType ?? .words,
      partialSearch: self.partialSearch ?? false,
      pageNumber: self.pageNumber ?? 1,
      pageSize: self.pageSize ?? 25)
  }

}

/// A container to encapsulate UMLS version information.
public struct UMLSVersion: Equatable {

  /// UMLS version release.
  public enum Release: String {
    case aa = "AA"
    case ab = "AB"
  }

  /// Release year for the UMLS.
  public enum ReleaseYear: Int {
    case year2008 = 2008
    case year2009 = 2009
    case year2010 = 2010
    case year2011 = 2011
    case year2012 = 2012
    case year2013 = 2013
    case year2014 = 2014
    case year2015 = 2015
    case year2016 = 2016
    case year2017 = 2017
    case year2018 = 2018
    case year2019 = 2019
    case year2020 = 2020
    case year2021 = 2021
    case year2022 = 2022
    case year2023 = 2023
    case year2024 = 2024
  }

  /// The release year of the UMLS.
  public let year: ReleaseYear
  /// Release part of UMLS version.
  public let release: Release

  /// Initialise `UMLSVERSION` object.
  /// - Parameters:
  ///   - year: Year of release.
  ///   - release: Major and minor release.
  public init(year: ReleaseYear, release: Release) {
    self.year = year
    self.release = release
  }

  /// UMLS version string conversion error
  public enum VersionStringError: Error, Equatable {
    case invalidlength
    case invalidYear(string: String)
    case unsupportedYear(year: Int)
    case unsupportedRelease(release: String)
  }

  /// Initialize ``UMLSVersion`` using a string.
  ///
  /// The initializer will raise a “VersionStringError.invalidlength” error when `string` is not of length 6.
  /// The initializer will raise a `VersionStringError.invalidYear(string:)` error when the
  /// first 4 characters can't be converted to an integer. The initializer will raise
  /// `VersionStringError.unsupportedYear(year:)` on an unsupported year in a string.
  /// The initializer will raise `VersionStringError.unsupportedRelease(release:)` on an
  /// unsupported release part in a string.
  ///
  /// - Parameter string: A UMLS version string.
  /// - Throws: Raise ``VersionStringError`` on an ill formatted string.
  public init(string: String) throws {

    guard string.count == 6 else {
      throw VersionStringError.invalidlength
    }

    let yearString = String(string[..<String.Index(utf16Offset: 4, in: string)])
    guard
      let number = Int(yearString)
    else {
      throw VersionStringError.invalidYear(string: yearString)
    }

    guard
      let year = ReleaseYear(rawValue: number)
    else {
      throw VersionStringError.unsupportedYear(year: number)
    }

    let releaseString = String(
      string[
        String.Index(utf16Offset: 4, in: string)..<String.Index.init(utf16Offset: 6, in: string)
      ]
    )
    guard
      let release = Release(rawValue: releaseString)
    else {
      throw VersionStringError.unsupportedRelease(release: releaseString)
    }

    self.init(year: year, release: release)

  }

}

extension UMLSVersion: CustomStringConvertible {

  /// Returns string representation of ``UMLSVersion``.
  public var description: String {
    "\(year.rawValue)\(release.rawValue)"
  }

}

/// Decodes search error response.
public struct SearchErrorInfo: Decodable, Sendable {

  /// The name of the error
  public let code: String
  /// The explanation of respective `code`.
  public let message: String

  enum CodingKeys: String, CodingKey {
    case code = "name"
    case message
  }

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<SearchErrorInfo.CodingKeys> = try decoder.container(
      keyedBy: SearchErrorInfo.CodingKeys.self)
    self.code = try container.decode(String.self, forKey: SearchErrorInfo.CodingKeys.code)
    self.message = try container.decode(String.self, forKey: SearchErrorInfo.CodingKeys.message)
  }

}

/// The possible search errors.
public enum SearchError: Error {
  // Describes the search is unauthorized.
  case unauthorized
  // Describes client error with error information.
  case searchError(info: SearchErrorInfo)
  // Other error which is not defined.
  case unknown
}
