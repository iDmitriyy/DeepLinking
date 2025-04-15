//
//  DeepLinkProtocol.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 15.12.2024.
//

// MARK: - DeepLink Protocol

// ⚠️ @iDmitriyy
// TODO: - ? make UniversalLinkProtocol LosslessStringConvertible too?
// ? DeepLinkThrowableProtocol – var url: throws URL 

public protocol DeepLinkProtocol: InAppLinkProtocol, LosslessStringConvertible {
  associatedtype Discriminant: DeepLinkDiscriminant
  
  static var scheme: String { get }
  
  var discriminant: Discriminant { get }
  
  var url: URL { get }
  
  init(deepLinkURL: URL) throws
}

public protocol DeepLinkDiscriminant: InAppLinkDiscriminant {
  var host: String? { get }
}

// MARK: LosslessStringConvertible default imp

extension DeepLinkProtocol {
  public var description: String { url.absoluteString }
  
  public init?(_ description: String) {
    guard let deepLinkURL = URL(string: description) else { return nil }
    try? self.init(deepLinkURL: deepLinkURL)
  }
}
