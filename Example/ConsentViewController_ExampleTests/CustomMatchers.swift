//
//  CustomMatchers.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 25.01.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
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

private func assertDecodeToValue<T: Decodable & Equatable>(_ expected: T, _ actual: Data) -> (Bool, String) {
    do {
        let value = try JSONDecoder().decode(T.self, from: actual)
        return value == expected ?
        (true, "pass") :
        (false, "Expected \(expected), but decoded into \(value)")
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

/// expect(string).to(decodeTo(Decodable.Type))
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

/// expect(string).to(decodeToValue(Decodable))
public func decodeToValue<T: Decodable & Equatable>(_ expected: T) -> Predicate<String> {
    Predicate { actual in
        guard let actual = try actual.evaluate(),
              let data = actual.data(using: .utf8) else {
            return PredicateResult(bool: false, message: .fail("could not convert string into Data").appendedBeNilHint())
        }
        let (pass, message) = assertDecodeToValue(expected, data)
        return PredicateResult(bool: pass, message: .fail(message))
    }
}

private func assertEncodeToValue(_ expected: Encodable, _ actual: Data) -> (Bool, String) {
    do {
        let value = try JSONEncoder().encode(expected)
        return value == actual ?
        (true, "pass") :
        (false, "Expected \(expected), but decoded into \(value)")
    } catch let EncodingError.invalidValue(value, context) {
        return (false, "Value \(value): \(context.debugDescription)")
    } catch {
        return (false, error.localizedDescription)
    }
}

/// expect(string).to(encodeToValue(Encodable))
public func encodeToValue<T: Encodable>(_ expected: String) -> Predicate<T> {
    Predicate { actual in
        guard let actual = try actual.evaluate(),
              let data = expected.data(using: .utf8) else {
            return PredicateResult(bool: false, message: .fail("could not convert string into Data").appendedBeNilHint())
        }
        let (pass, message) = assertEncodeToValue(actual, data)
        return PredicateResult(bool: pass, message: .fail(message))
    }
}
