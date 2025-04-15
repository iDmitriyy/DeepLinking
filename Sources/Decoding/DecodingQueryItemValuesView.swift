//
//  DecodingQueryItemValuesView.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 06.03.2025.
//

// ⚠️ @iDmitriyy
// TODO: - make URLQueryValuesView from prototype to final
// - Not View yet, just wrapper like _Sequence type LazyMapAAequence
// - ? lifetime dependency

public struct URLQueryValuesView<Base: URLQueryValueProvidable> {
  internal let _base: Base
  
  public init(_ provider: Base) {
    _base = provider
  }
}

// MARK: single String Value

extension URLQueryValuesView {
  public var elements: some RandomAccessCollection<(key: String, value: String?)> {
    _base.allQueryElements()
  }
  
  public subscript(_ key: String) -> String? {
    _base.queryItemValue(named: key)
  }
  
  public subscript(_ key: String) -> String {
    get throws { try _base.queryItemValue(named: key) }
  }
}

// MARK: - With Lossless String Conversion (single value)

extension URLQueryValuesView {
  public subscript<A>(_ key: String) -> A? where A: LosslessStringConvertible {
    get throws { try _base.queryItemValue(named: key) }
  }
  
  public subscript<A>(_ key: String) -> A where A: LosslessStringConvertible {
    get throws { try _base.queryItemValue(named: key) }
  }
  
  public subscript<A>(_ key: String) -> Transform<A> where A: LosslessStringConvertible {
    get throws {
      let value: A = try _base.queryItemValue(named: key)
      return Transform(wrapped: value)
    }
  }
}

// MARK: - With Lossless String Conversion (multiple values)

extension URLQueryValuesView {
  // MARK: arity = 2
  
  public subscript<A, B>(_ keyA: String, _ keyB: String) -> (A, B)
    where A: LosslessStringConvertible, B: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB) }
  }
  
  public subscript<A, B>(_ keyA: String, _ keyB: String) -> (A?, B)
    where A: LosslessStringConvertible, B: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB) }
  }
  
  public subscript<A, B>(_ keyA: String, _ keyB: String) -> (A, B?)
    where A: LosslessStringConvertible, B: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB) }
  }
  
  public subscript<A, B>(_ keyA: String, _ keyB: String) -> (A?, B?)
    where A: LosslessStringConvertible, B: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB) }
  }
}

extension URLQueryValuesView {
  // MARK: arity = 3
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A, B, C)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A?, B, C)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A, B?, C)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A?, B?, C)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A, B, C?)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A?, B, C?)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A, B?, C?)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
  
  public subscript<A, B, C>(_ keyA: String, _ keyB: String, _ keyC: String) -> (A?, B?, C?)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    get throws { try _base.queryItemValues(named: keyA, keyB, keyC) }
  }
}

extension URLQueryValuesView {
  // MARK: Separated functions for required & optional values | arity >=2
  
  // Optional:
    
  public func optional<A, B, each L>(_ keyA: String, _ keyB: String, _ otherKeys: String...) throws
    -> (A?, B?, repeat Optional<each L>)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, repeat each L: LosslessStringConvertible {
      try _base._optionalQueryItemValues(named: keyA, keyB, otherKeys)
    }
  
  public func optional<each L>(_ keys: [String]) throws -> (repeat Optional<each L>)
    where repeat each L: LosslessStringConvertible {
      try _base.optionalQueryItemValues(named: keys)
    }
  
  // Required:
  
  public func required<A, B, each L>(_ keyA: String, _ keyB: String, _ otherKeys: String...) throws
    -> (A, B, repeat each L)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, repeat each L: LosslessStringConvertible {
      try _base._requiredQueryItemValues(named: keyA, keyB, otherKeys)
    }
  
  public func required<each L>(_ keys: [String]) throws -> (repeat each L)
    where repeat each L: LosslessStringConvertible {
      try _base.requiredQueryItemValues(named: keys)
    }
}

// MARK: - Atypical cases

// MARK: Multiple values for single key

// While there is no definitive standard, most web frameworks allow multiple values to be associated with a single field
// (e.g. field1=value1&field1=value2&field2=value3)
// (https://en.wikipedia.org/wiki/Query_string)

extension URLQueryValuesView {
  public func allValues(forKey key: String) -> some Collection<String?> {
    _base.allQueryItemValues(forKey: key)
  }
  
  /// for cases when the key is repeated a specific and known number of times.
  /// When number of occurences of a given query is unknown or can be different, than us
  public func multipleValues<each S>(forKey key: String) throws -> (String?, String?, repeat Optional<each S>)
    where repeat each S: StringProtocol {
      try _base.multipleQueryItemValues(forKey: key)
    }
}

// MARK: - Transform Type

public struct Transform<T: ~Copyable>: ~Copyable {
  private let wrapped: T
  
  internal init(wrapped: consuming T) {
    self.wrapped = wrapped
  }
  
  public func transform<E, U>(_ transform: (borrowing T) throws(E) -> U)
    throws(E) -> U where E: Error, U: ~Copyable {
    try transform(wrapped)
  }
  
  /// For transform chaining
  @_disfavoredOverload
  public func transform<E, U>(_ transform: (borrowing T) throws(E) -> U)
    throws(E) -> Transform<U> where E: Error, U: ~Copyable {
    let transformedValue = try transform(wrapped)
    return Transform<U>(wrapped: transformedValue)
  }
}

extension Transform: Copyable where T: Copyable {}
