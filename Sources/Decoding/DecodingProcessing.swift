//
//  DecodingProcessing.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 02.01.2025.
//

import struct Foundation.URLComponents
@_spiOnly @_spi(SwiftyKitBuiltinTypes) private import struct SwiftyKit.TextError

internal protocol _OptionalProtocol<Wrapped>: ~Copyable {
  associatedtype Wrapped
}

extension Optional: _OptionalProtocol {}

// MARK:  URL Template Matching

extension InAppLinkDiscriminant {
  /// Позволяет понять, совпадает ли путь ссылки с pathTemplate Discriminant'а.
  /// Например для "/profile/orders/status/\(Self.pathPlaceholder)" и /profile/orders/status/88717387 вернёт true.
  /// - Parameters:
  ///   - urlPath: path, взятый из URL'a UniversalLink или DeepLink ссылки, по которому нажал пользователь
  ///   - pathTemplate: pathTemplate Discriminant'а
  /// - Returns: кортеж из 2 параметров.
  /// matches: Bool – true, если urlPath соответсвует pathTemplate.
  /// extractedComponents – компоненты из urlPath, которые были на местах плейсхолдеров в pathTemplate. Например
  /// если pathTemplate = "/profile/status/\(Self.pathPlaceholder)/etc/\(Self.pathPlaceholder)", то из urlPath "/profile/status/123/etc/abc"
  /// будет извлечены ["123", "abc"], которые потом можно преобразовать в типизированные значения.
  public static func urlPath(_ urlPath: String,
                             matchesPathTemplate pathTemplate: String) -> (matches: Bool, extractedComponents: [String]) {
    let urlPathComponents = URLComponents.pathComponents(path: urlPath)
    let discriminantPathComponents = URLComponents.pathComponents(path: pathTemplate)
    
    guard urlPathComponents.count == discriminantPathComponents.count else {
      return (false, [])
    }
    // ⚠️ @iDmitriyy
    // FIXME: - а что если будет пустой путь вида "" или "/" или "//"?
    // или только дженерик компонет "\(Self.pathPlaceholder)"
    
    // Ссылка вида /main/a/b будет триггериться на:
    // /main/a/{placeholder}
    // /main/{placeholder}/{placeholder}
    // ? Нужно это отлавливать в аномалиях ?
    // или это валидный кейс, и как тогда его решать. Варианты:
    // - искать все дискриминанты с походящими темплейтами. Сначала ищется более конкретный, т.е. /main/a/
    // если ссылка с ним не сопоставляется, то переходим к следующему конкретному, потом к общему. Общий должен быть макс один.
    // Получается, нужно придумать что-то типа Identity с операторами ==, ~=, isEqual
    // структурно, еасли какой-то компонент в любом из 2 шаблнов == {placeholder}, то структурно они оверлапятся.
    
    // Проверяем что путь соответствует маске (дженерику)
    let pairs = zip(urlPathComponents, discriminantPathComponents)
    
    let areEqual = pairs.allSatisfy { urlPathComponent, discriminantPathComponent -> Bool in
      // В тех местах, где есть плэйсхолдеры, возвращаем true, т.к. любое значение подходит
      guard discriminantPathComponent != pathPlaceholder else { return true }
      // Остальные компоненты сравниваем
      return urlPathComponent == discriminantPathComponent
    }
    
    // Находим индексы плейсхолдеров и достаём по этим индексам компоненты из реального пути
    let placeholderIndices = discriminantPathComponents.enumerated().compactMap { index, component -> Int? in
      component == pathPlaceholder ? index : nil
    }
    
    let extractedComponents = placeholderIndices.map { index in urlPathComponents[index] }
    
    return (areEqual, extractedComponents)
  }
  
  // > early prototype
  internal static func pathValues_v<each L>(fromComponents components: [String]) throws -> (repeat each L)
    where repeat each L: LosslessStringConvertible {
      lazy var anError = TextError(text: "Invalid path")
      lazy var anError2 = TextError(text: "Type conversion failed")
      
      var index: Int = 0
      func transformNextValue<O>(toType instanceType: O.Type) throws -> O where O: LosslessStringConvertible {
        defer { index += 1 }
        guard let stringValue = components[at: index] else { throw anError }
        
        if let instance = instanceType.init(stringValue) {
          return instance
        } else {
          throw anError2
        }
      }
      
      let result: (repeat each L) = (repeat try transformNextValue(toType: (each L).self))
      
      do { // попытка избавиться от создания функции-костыля transformNextValue()
//        let types: (repeat (each L).Type) = (repeat (each L).self)
//        var index: Int = 0
//        for instanceType in repeat each types {
//          defer { index += 1 }
//          guard let stringValue = components[at: index] else { throw anError }
//          
//          if let instance = instanceType.init(stringValue) {
//            return instance
//          } else {
//            throw anError2
//          }
//        }
      }
      
      guard index == components.endIndex else { throw anError } // components.count > tuple.count
      
      return result
  }
  
  static func dd() {
    let ddd = try! pathValues_v(fromComponents: []) as ()
    let aaa = try! pathValues_v(fromComponents: []) as (Int, String, Double)
    type(of: aaa).self
    type(of: ddd).self
  }
  
//  @available(*, deprecated, message: "Empty tuple can not be used for extracting path values")
//  internal static func pathValues_v(fromComponents components: [String]) throws {
//    // ambiguous use
//  }
  
  public static func _testHasPathTemplatesCollisions() -> [String] {
    // ⚠️ @iDmitriyy
    // TODO: - сделать тест на предмет того, что есть эквивалентные темплэйты.
    // - например "\(placeholder)/\(placeholder)" у двух "\(placeholder)/other/\(placeholder)"
    // решение: написать функцию, которая через CaseIterable вытащит все pathTemplte и
    // Теситовая функция должна быть заточена под urlPath(_:, matchesPathTemplate:)
    for instance in allCases {}
    
    return []
  }
  
  ///
  /// - Parameters:
  ///   - pathTemplates:
  ///   - placeholder:
  /// - Returns:
  ///
  /// The following checks are made for each pathTemplate:
  /// - at least 1 path component exist
  /// - 1st component is not a placeholder
  /// - all components can't be placeholders
  /// - is not equal to another template (duplicated)
  internal static func testForAnomalies(pathTemplates: [String], placeholder: String) -> [String] {
    var templates: Set<String> = []
    
    for template in pathTemplates {
      var messages: [String] = []
      defer {} // /??
      
      let lowercasedComponents = URLComponents.pathComponents(path: template.lowercased())
      guard let firstComponent = lowercasedComponents.first else {
        messages.append("no path components found")
        continue // ????????
      }
      
      // ⚠️ @iDmitriyy
      // TODO: - disallowed characters
      
      // ? как
      // /main/placeholder
      // /main/placeholder/placeholder
      // /main/placeholder/placeholder/placeholder
      
      let isFirstPlaceholder = firstComponent == placeholder
      switch lowercasedComponents.count {
      case 1:
        if isFirstPlaceholder { messages.append("The only one component of pathTemplate is a placeholder") }
      default:
        let others = lowercasedComponents[1...]
        let isOthersPlaceholder = others.isEmpty ? false : others.allSatisfy { $0 == placeholder }
        
        switch (isFirstPlaceholder, isOthersPlaceholder) {
        case (true, true): messages.append("Template contains only placeholders")
        case (true, false): messages.append("First component of pathTemplate is a placeholder")
        case (false, true),
             (false, false): break // ok
        }
      }
      
      let refinedTamplate = lowercasedComponents.joined(separator: "/")
      
      if !templates.insert(refinedTamplate).inserted {
        messages.append("pathTemplate duplicated")
      }
    }
    
    return []
  }
}
