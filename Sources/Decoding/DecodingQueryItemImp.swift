//
//  DecodingQueryItemImp.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 07.03.2025.
//

@_spiOnly @_spi(SwiftyKitBuiltinTypes) private import struct SwiftyKit.TextError

// MARK: Single required raw string value

extension URLQueryValueProvidable {
  package func queryItemValue(named name: String) throws -> String {
    guard let stringValue: String = queryItemValue(named: name) else { throw errorRequiredValue(forKey: name) }
    return stringValue
  }
}

// MARK: - With Lossless String Conversion (single value)

extension URLQueryValueProvidable {
  package func queryItemValue<A>(named name: String) throws -> A? where A: LosslessStringConvertible {
    let stringValue: String? = queryItemValue(named: name)
    return try stringValue.map { try Self.convert(stringValue: $0) as A }
  }
  
  package func queryItemValue<A>(named name: String) throws -> A where A: LosslessStringConvertible {
    let stringValue: String = try queryItemValue(named: name)
    return try Self.convert(stringValue: stringValue)
  }
}

// MARK: - With Lossless String Conversion (multiple values)

extension URLQueryValueProvidable {
  // MARK: arity = 2
  
  package func queryItemValues<A, B>(named nameA: String, _ nameB: String) throws
    -> (A, B) where A: LosslessStringConvertible, B: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB))
  }
  
  package func queryItemValues<A, B>(named nameA: String, _ nameB: String) throws
    -> (A?, B) where A: LosslessStringConvertible, B: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB))
  }
  
  package func queryItemValues<A, B>(named nameA: String, _ nameB: String) throws
    -> (A, B?) where A: LosslessStringConvertible, B: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB))
  }
  
  package func queryItemValues<A, B>(named nameA: String, _ nameB: String) throws
    -> (A?, B?) where A: LosslessStringConvertible, B: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB))
  }
}

extension URLQueryValueProvidable {
  // MARK: Arity == 3
  
  package func queryItemValues<A, B, C>(named nameA: String,
                                        _ nameB: String,
                                        _ nameC: String) throws
    -> (A, B, C) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
   
  package func queryItemValues<A, B, C>(named nameA: String,
                                        _ nameB: String,
                                        _ nameC: String) throws
    -> (A?, B, C) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
  
  package func queryItemValues<A, B, C>(named nameA: String, _ nameB: String, _ nameC: String) throws
    -> (A, B?, C) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
  
  package func queryItemValues<A, B, C>(named nameA: String, _ nameB: String, _ nameC: String) throws
    -> (A?, B?, C) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
  
  package func queryItemValues<A, B, C>(named nameA: String, _ nameB: String, _ nameC: String) throws
    -> (A, B, C?) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
  
  package func queryItemValues<A, B, C>(named nameA: String, _ nameB: String, _ nameC: String) throws
    -> (A?, B, C?) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
  
  package func queryItemValues<A, B, C>(named nameA: String, _ nameB: String, _ nameC: String) throws
    -> (A, B?, C?) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
  
  package func queryItemValues<A, B, C>(named nameA: String, _ nameB: String, _ nameC: String) throws
    -> (A?, B?, C?) where A: LosslessStringConvertible, B: LosslessStringConvertible, C: LosslessStringConvertible {
    try ensure(keysAreUniqie: [nameA, nameB, nameC])
    return try (queryItemValue(named: nameA), queryItemValue(named: nameB), queryItemValue(named: nameC))
  }
}

extension URLQueryValueProvidable {
  // MARK: Separated functions for required & optional values | arity >=2
  
  // Optional:
  
  package func optionalQueryItemValues<A, B, each L>(named nameA: String, _ nameB: String, _ otherNames: String...) throws
    -> (A?, B?, repeat Optional<each L>)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, repeat each L: LosslessStringConvertible {
      try _optionalQueryItemValues(named: nameA, nameB, otherNames)
    }
  
  internal func _optionalQueryItemValues<A, B, each L>(named nameA: String, _ nameB: String, _ otherNames: [String]) throws
    -> (A?, B?, repeat Optional<each L>)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, repeat each L: LosslessStringConvertible {
      try ensure(keysAreUniqie: [nameA, nameB] + otherNames)
      let (a, b) = try queryItemValues(named: nameA, nameB) as (A?, B?)
      let others: (repeat (each L)?) = try optionalQueryItemValues(named: otherNames)
      return (a, b, repeat each others)
    }

  package func optionalQueryItemValues<each L>(named names: [String]) throws
    -> (repeat Optional<each L>) where repeat each L: LosslessStringConvertible {
      try ensure(keysAreUniqie: names)
      // In `queryItemValues(named:)` functions number of arguments and returned values is equal and defined by func signatures.
      // Here we define the same eqaulity, but check is done in runtime.
      guard names.count == variadicParamsCount(repeat (each L).self) else {
        throw errorCountKeys(names, notEqualToOutput: repeat (each L).self)
      }
    
      var currentIndex: Int = 0
      func processNext<T: LosslessStringConvertible>(_: T.Type) throws -> T? {
        defer { currentIndex += 1 }
        let name = names[currentIndex]
        return try queryItemValue(named: name)
      }
    
      let result = try (repeat processNext((each L).self))
      return result
    }
  
  // Required:
  
  package func requiredQueryItemValues<A, B, each L>(named nameA: String, _ nameB: String, _ otherNames: String...) throws
    -> (A, B, repeat each L)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, repeat each L: LosslessStringConvertible {
      try _requiredQueryItemValues(named: nameA, nameB, otherNames)
    }
  
  /// reusable imp for func & subscript with variadic arguments
  internal func _requiredQueryItemValues<A, B, each L>(named nameA: String, _ nameB: String, _ otherNames: [String]) throws
    -> (A, B, repeat each L)
    where A: LosslessStringConvertible, B: LosslessStringConvertible, repeat each L: LosslessStringConvertible {
      try ensure(keysAreUniqie: [nameA, nameB] + otherNames)
      let (a, b) = try queryItemValues(named: nameA, nameB) as (A, B)
      let others: (repeat each L) = try requiredQueryItemValues(named: otherNames)
      // ⚠️ @iDmitriyy
      // TODO: - error text will be incorrect because user expect the count of all keys, but only otherNames.count is used
      // inside underlying fnction
      return (a, b, repeat each others)
    }
  
  package func requiredQueryItemValues<each L>(named names: [String]) throws
    -> (repeat each L) where repeat each L: LosslessStringConvertible {
      try ensure(keysAreUniqie: names)
      // In `queryItemValues(named:)` functions number of arguments and returned values is equal and defined by func signatures.
      // Here we define the same eqaulity, but check is done in runtime.
      guard names.count == variadicParamsCount(repeat (each L).self) else {
        throw errorCountKeys(names, notEqualToOutput: repeat (each L).self)
      }
    
      var currentIndex: Int = 0
      func processNext<T: LosslessStringConvertible>(_: T.Type) throws -> T {
        defer { currentIndex += 1 }
        let name = names[currentIndex]
        return try queryItemValue(named: name)
      }
    
      let result = try (repeat processNext((each L).self))
      return result
    }
}

// MARK: - Atypical cases

// MARK: Multiple values for single key

extension URLQueryValueProvidable {
  /// for cases when the key is repeated a specific and known number of times
  ///
  /// StringProtocol is used for making variadic output because of current language limitations.  String Type is supposed to be used.
  package func multipleQueryItemValues<each S>(forKey key: String) throws -> (String?, String?, repeat Optional<each S>)
    where repeat each S: StringProtocol {
      let allValues = allQueryItemValues(forKey: key)
      
      let expectedValuesCount = 2 + variadicParamsCount(repeat (each S).self)
      guard allValues.count == expectedValuesCount else {
        throw errorCountFoundValues(allValues, forKey: key, notEqualTo: expectedValuesCount)
      }
    
      let index0 = allValues.startIndex
      let index1 = allValues.index(after: index0)
      
      let a = allValues[index0]
      let b = allValues[index1]
    
      let index2 = allValues.index(after: index1)
      let otherValues = allValues[index2...]
    
      var currentIndex = otherValues.startIndex
      func processNext<T: StringProtocol>(_: T.Type) -> T? {
        defer { currentIndex = otherValues.index(after: currentIndex) }
        let element = otherValues[currentIndex]
      
        return if let string = element {
          T(string)
        } else {
          nil
        }
      }
  
      let others: (repeat (each S)?) = (repeat processNext((each S).self))
      return (a, b, repeat each others)
    }
}

// MARK: - Error-building functions

// ⚠️ @iDmitriyy
// TODO: - replace `any Error` to `some Error` later. Compiler crashes at XCode 16.2

// ⚠️ @iDmitriyy
// FIXME: - доработать ошибки
// по хорошему для (each L).Type надо в тексте ошибок указывать и отличать опциооналы от неопционалов, иначе не совсем понятно
// о какой перезагрузке функции идет речь
// Что #function сгенерит для subscript'a

fileprivate func errorRequiredValue(forKey key: String) -> any Error {
  TextError(text: "Required value for key `\(key)` not found")
}

fileprivate func errorCountKeys<each L>(_ keys: [String], notEqualToOutput types: repeat (each L).Type) -> any Error {
  let returnValuesCount = variadicParamsCount(repeat each types)
  let returnValuesDescr = variadicTypesDescription(repeat each types)
  let text = "Keys count \(keys.count) is not equal to returned values count \(returnValuesCount), "
    + "keys: \(keys), types: " + returnValuesDescr
  return TextError(text: text)
}

fileprivate func errorCountFoundValues(_ values: some Collection<String?>,
                                       forKey key: String,
                                       notEqualTo expectedCount: Int) -> any Error {
  let text = "Count(\(values.count)) of found values for key `\(key)` is not equal to expected count \(expectedCount) of values"
  return TextError(text: text)
}

internal func errorInitQueryValueFromString<T>(_ stringValue: String, ofType type: T.Type) -> any Error {
  TextError(text: "Failed to initialize query value of type \(type.self) from \(stringValue)")
}

fileprivate func ensure(keysAreUniqie keys: [String]) throws {
  guard keys.count == Set(keys).count else {
    let text = "Keys \(keys) are assumed to be unique but contain duplicates."
    throw TextError(text: text)
  }
}
