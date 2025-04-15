//
//  EncodingProcessing.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 02.01.2025.
//

import struct Foundation.URLComponents
@_spiOnly @_spi(SwiftyKitBuiltinTypes) private import struct SwiftyKit.TextError

// MARK: - Encoding to Raw

extension InAppLinkProtocol {
  // ⚠️ @iDmitriyy
  // FIXME: - LosslessStringConvertible или CustomStringConvertible? надо обхяснить и как-то связать почему именно
  // LosslessStringConvertible и пример когда использование CustomStringConvertible не позволит сделать обратное преоращование
  
  /// Заменяет pathPlaceholder в pathTemplate дискриминанта на конкретное значение.
  /// Например если передать pathTemplate "/profile/orders/status/\(Self.pathPlaceholder)" и число 9999, то получится
  /// "/profile/orders/status/9999"
  public static func replacePlaceholders<each L>(inPathTemplate pathTemplate: String,
                                                 with pathValues: repeat each L) throws -> String
    where repeat each L: LosslessStringConvertible {
      var stringValues: [String] = []
      for pathValue in repeat each pathValues {
        stringValues.append(String(pathValue))
      }
      return try replacePlaceholders(inPathTemplate: pathTemplate, with: stringValues)
    }
  
  package static func replacePlaceholders(inPathTemplate pathTemplate: String,
                                          with pathValues: [String]) throws -> String {
    lazy var anError =
      TextError(text: "Params and paleholders mismatch, pathTemplate: \(pathTemplate), values count: \(pathValues.count)")
    
    var path = pathTemplate
    
    for pathValue in pathValues {
      if let range = path.range(of: pathPlaceholder) {
        path.replaceSubrange(range, with: pathValue)
      } else {
        throw anError
      }
    }
    
    if path.range(of: pathPlaceholder) != nil { throw anError }
    
    return path
  }
}
