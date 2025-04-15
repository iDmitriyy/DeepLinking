//
//  UniversalLinkProtocol.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 02.01.2025.
//

import struct Foundation.URL

// MARK: - UniversalLink Protocol

public protocol UniversalLinkProtocol: InAppLinkProtocol {
  associatedtype Discriminant: InAppLinkDiscriminant
  
  /// Список валидных схем, например http, https
  static var schemes: Set<String> { get }
  /// Список валидных хостов
  static var hosts: Set<String> { get }
  
  var scheme: String { get }
  var host: String { get }
  
  init(url: URL) throws
}
