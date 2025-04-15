//
//  DecodingQueryItem.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 04.03.2025.
//

import struct Foundation.URLComponents
import struct Foundation.URLQueryItem

// MARK: - Protocol

public protocol URLQueryValueProvidable {
  func queryItemValue(named name: String) -> String?
  
  associatedtype QueryRawValuesCollection: RandomAccessCollection<String?>
  func allQueryItemValues(forKey key: String) -> QueryRawValuesCollection
  
  associatedtype QueryRawElementsCollection: RandomAccessCollection<(key: String, value: String?)>
  func allQueryElements() -> QueryRawElementsCollection
  
  var queryValuesView: URLQueryValuesView<Self> { get }
}

// MARK: public functions with default imp

extension URLQueryValueProvidable {
  public static func convert<T: LosslessStringConvertible>(stringValue: String,
                                                           toType targetType: T.Type = T.self) throws -> T {
    guard let instance = T(stringValue) else { throw errorInitQueryValueFromString(stringValue, ofType: targetType) }
    return instance
  }
}
