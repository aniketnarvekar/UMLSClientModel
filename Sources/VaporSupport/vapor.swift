// vapor.swift

import Foundation
import UMLSClientModel
import Vapor

extension UMLSPostalAddress: Content {}

extension UMLSCreatorContact: Content, RequestDecodable, ResponseEncodable, AsyncRequestDecodable,
  AsyncResponseEncodable
where Address: Content {}

extension UMLSLicenseContact: Content, RequestDecodable, ResponseEncodable, AsyncRequestDecodable,
  AsyncResponseEncodable
where Address: Content {}

extension UMLSLanguageInfo: Content {}

extension UMLSSourceVocabularyInfo: Content, RequestDecodable, ResponseEncodable,
  AsyncRequestDecodable, AsyncResponseEncodable
where LicenseContact: Content, CreatorContact: Content, Language: Content {}

extension UMLSSourceVocabularyTypeObject: Content, RequestDecodable, ResponseEncodable,
  AsyncRequestDecodable, AsyncResponseEncodable
where Self.Object: Content {}
