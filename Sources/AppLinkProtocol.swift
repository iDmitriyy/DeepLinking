//
//  InAppLinkProtocol.swift
//  swifty-kit
//
//  Created by Dmitriy Ignatyev on 02.01.2025.
//

public protocol InAppLinkProtocol: Sendable {}

extension InAppLinkProtocol {
  public static var pathPlaceholder: String { _inAppLinkPathTemplateComponentPlaceholder }
  // ⚠️ @iDmitriyy
  // TODO: - rename to pathComponentPlaceHolder ??
}

// MARK: - Discriminant Protocol

public protocol InAppLinkDiscriminant: CaseIterable, Equatable, Sendable {
  var pathTemplate: String { get }
  
  static func make(urlPath: String) -> (discriminant: Self, extractedComponents: [String])?
}

extension InAppLinkDiscriminant {
  public static func make(urlPath: String) -> (discriminant: Self, extractedComponents: [String])? {
    let instance = try? Self(value: urlPath, relatedTo: \.pathTemplate, predicate: { urlPath, pathTemplate -> Bool in
      let (matches, _) = Self.urlPath(urlPath, matchesPathTemplate: pathTemplate)
      return matches
    })
    
    guard let instance else { return nil }
    // ⚠️ @iDmitriyy
    // FIXME: - 2 раза вызывается matchesPathTemplate
    // rename pathPlaceholder -> pathComponentPlaceholder
    let (_, extractedComponents) = Self.urlPath(urlPath, matchesPathTemplate: instance.pathTemplate)
    
    return (instance, extractedComponents)
  }
}

extension InAppLinkDiscriminant {
  public static var pathPlaceholder: String { _inAppLinkPathTemplateComponentPlaceholder }
}

// MARK: - InAppLink Payload

// ⚠️ @iDmitriyy
// TODO: -
protocol InAppLinkPayload {
  static func convert()
}

// struct Baz {
//     let title:  String
//    init(title: const String) {
//        self.title = title
//    }
// }

/*
 public protocol URLConvertible {
   func asURL() throws -> URL
   init(urlString: String)
 }
 
 extension URLConvertible {
   
 }

 extension URL: URLConvertible {
   public func asURL() throws -> URL { self }
 }
 // сделать ли возмоджнось испольовать как URL так и WebURL для диплинков?
 // кажется, это имеет смысл
  */

// MARK: - Generic Path Component

@usableFromInline internal let _inAppLinkPathTemplateComponentPlaceholder: String = "{>`<}"
