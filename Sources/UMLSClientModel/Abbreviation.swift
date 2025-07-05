// Abbreviation.swift

import Foundation

/// The UMLS language name
public enum UMLSLanguageName: String, Codable, CaseIterable, Sendable {
  case arabic = "Arabic"
  case basque = "Basque"
  case chinese = "Chinese"
  case czech = "Czech"
  case danish = "Danish"
  case dutch = "Dutch"
  case english = "English"
  case estonian = "Estonian"
  case finnish = "Finnish"
  case french = "French"
  case german = "German"
  case greek = "Greek"
  case hebrew = "Hebrew"
  case hungarian = "Hungarian"
  case italian = "Italian"
  case japanese = "Japanese"
  case korean = "Korean"
  case latvian = "Latvian"
  case norwegian = "Norwegian"
  case polish = "Polish"
  case portuguese = "Portuguese"
  case russian = "Russian"
  case croatian = "Croatian"
  case spanish = "Spanish"
  case swedish = "Swedish"
  case turkish = "Turkish"
  case ukrainian = "Ukrainian"
}

public enum UMLSContextType: String, Codable, Sendable, CaseIterable {
  case full = "FULL"
  case fullMultiple = "FULL-MULTIPLE"
  case none = "NONE"
}
