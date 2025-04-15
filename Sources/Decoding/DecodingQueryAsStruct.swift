//
//  DecodingQueryAsStruct.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 08.03.2025.
//

import Foundation
@_spiOnly @_spi(SwiftyKitBuiltinTypes) private import struct SwiftyKit.TextError

extension URLQueryValuesView {
  func decode<T: Decodable>(_: T.Type) throws -> T {
    let decoder = QueryDecoder()
    
    throw TextError(text: "Not implemented yet")
  }
}

internal struct QueryDecoder: Decoder {
  var codingPath: [any CodingKey] { [] }
  
  var userInfo: [CodingUserInfoKey: Any] { [:] }
  
  func container<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
    fatalError()
  }
  
  func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
    fatalError()
  }
  
  func singleValueContainer() throws -> any SingleValueDecodingContainer {
    fatalError()
  }
}

extension String {
  fileprivate var bool: Bool? {
    switch lowercased() {
    case "true", "yes", "1", "y": true
    case "false", "no", "0", "n": false
    default: nil
    }
  }
}
