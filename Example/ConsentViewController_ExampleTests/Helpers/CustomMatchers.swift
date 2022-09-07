//
//  CustomMatchers.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 07.09.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Nimble

private func assertDecode<T: Decodable>(_ expected: T.Type, _ actual: Data) -> (Bool, String) {
    do {
        _ = try JSONDecoder().decode(expected, from: actual)
        return (true, "pass")
    } catch let DecodingError.dataCorrupted(context) {
        return (false, context.debugDescription)
    } catch let DecodingError.keyNotFound(key, context) {
        return (false, "Key '\(key)' not found: \(context.debugDescription)\n codingPath: \(context.codingPath)")
    } catch let DecodingError.valueNotFound(value, context) {
        return (false, "Value '\(value)' not found: \(context.debugDescription)\n codingPath: \(context.codingPath)")
    } catch let DecodingError.typeMismatch(type, context) {
        return (false, "Type '\(type)' mismatch: \(context.debugDescription)\n codingPath: \(context.codingPath)")
    } catch {
        return (false, error.localizedDescription)
    }
}

/// expect(string).to(decodeTo(DecodableType))
public func decodeTo<T: Decodable>(_ expected: T.Type) -> Predicate<String> {
    Predicate { actual in
        guard let actual = try actual.evaluate(),
              let data = actual.data(using: .utf8) else {
                  return PredicateResult(bool: false, message: .fail("could not convert string into Data").appendedBeNilHint())
              }
        let (pass, message) = assertDecode(expected, data)
        return PredicateResult(bool: pass, message: .fail(message))
    }
}
