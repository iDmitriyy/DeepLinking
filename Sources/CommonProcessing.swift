//
//  _CommonProcessing.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 02.01.2025.
//

import struct Foundation.URLComponents
@_spiOnly @_spi(SwiftyKitBuiltinTypes) private import struct SwiftyKit.TextError

extension URLComponents {
  /// Создаёт массив компонентов пути, например "/profile/favorites" в виде ["profile", "favorites"].
  /// Отличается от url.pathComponents тем, что не содержит "/" в качестве первого элемента.
  public static func pathComponents(path: String) -> [String] {
    // ⚠️ @iDmitriyy
    // FIXME: - сравнить с работой url.pathComponents, мб использовать его и просто удалять первый /
    // добавить проверку на $0 != "/" и т.д.
    path.components(separatedBy: "/").filter { !$0.isEmpty }
  }
}

// MARK: - Helpers

@inlinable @inline(__always)
internal func variadicParamsCount<each T>(_ params: repeat each T) -> Int {
  var count: Int = 0
  for _ in repeat each params { count += 1 }
  return count
}

internal func variadicTypesDescription<each T>(_ types: repeat (each T).Type) -> String {
  var components: [String] = []
  for type in repeat each types { components.append(String(describing: type)) }
  let joined = components.joined(separator: ", ")
  return "(" + joined + ")"
}
