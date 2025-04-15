//
//  DefaultConformances.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 08.03.2025.
//

import struct Foundation.URLComponents
import struct Foundation.URLQueryItem

// MARK: - For Decoding query items

extension URLComponents: URLQueryValueProvidable {
  /// First value in query for a given key.
  public func queryItemValue(named name: String) -> String? {
    queryItems?.queryItemValue(named: name)
  }
  
  public func allQueryItemValues(forKey key: String) -> some RandomAccessCollection<String?> {
    (queryItems ?? []).allQueryItemValues(forKey: key)
  }
  
  public var queryValuesView: URLQueryValuesView<Self> { URLQueryValuesView(self) }
  
  public func allQueryElements() -> some RandomAccessCollection<(key: String, value: String?)> {
    (queryItems ?? []).map { ($0.name, $0.value) } // FIXME: inefficient?
  }
}

extension Array<URLQueryItem> {
  internal func queryItemValue(named name: String) -> String? {
    first(where: { $0.name == name })?.value
  }
  
  internal func allQueryItemValues(forKey key: String) -> [String?] {
    filter { $0.name == key }.map { $0.value }
  }
}

// extension WebURL: URLQueryValueProvidable {
//  internal func queryItemValue(named name: String) -> String? {
//    formParams.get(name)
//  }
//
//  // params.getAll("")
// }
