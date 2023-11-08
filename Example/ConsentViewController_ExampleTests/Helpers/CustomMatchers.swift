//
//  CustomMatchers.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 07.09.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Nimble
@testable import ConsentViewController

public typealias Predicate = Nimble.Predicate

extension URL {
    public var queryParams: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}

private func assertDecode<T: Decodable>(_ expected: T.Type, _ actual: Data) -> (Bool, String) {
    do {
        _ = try JSONDecoder().decode(expected, from: actual) as T
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
        let value = try JSONDecoder().decode(T.self, from: actual) as T
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

/// expect(url).to(containQueryParam("foo"))
public func containQueryParam(_ expected: String) -> Predicate<URL> {
    Predicate { actual in
        guard let actual = try actual.evaluate(),
              let params = actual.queryParams
        else {
            return PredicateResult(bool: false, message: .fail("could not get query params from URL"))
        }
        return PredicateResult(bool: params.keys.contains(expected), message: .fail("\(actual) does not contain \(expected) query param."))
    }
}

/// expect(url).to(containQueryParam(("name", "value")))
public func containQueryParam(_ name: String, withValue value: String) -> Predicate<URL> {
    Predicate { actual in
        guard let actual = try actual.evaluate(),
              let params = actual.queryParams
        else {
            return PredicateResult(bool: false, message: .fail("could not get query params from URL"))
        }
        var pass = false
        var message = ""
        if params.keys.contains(name) {
            if params.values.contains(value) {
                pass = true
            } else {
                message = "Expected param \(name) to equal \(value), but found \(params[name] ?? "")"
            }
        } else {
            message = "Could not find query param with name \(name) in \(actual.absoluteString)"
        }
        return PredicateResult(bool: pass, message: .fail(message))
    }
}

/// expect(spDate).to(equal(year: 123, month: 123, day: 123))
public func equal(year: Int? = nil, month: Int? = nil, day: Int? = nil) -> Predicate<SPDate> {
    Predicate { actual in
        guard let actual = try actual.evaluate() else {
            return PredicateResult(bool: false, message: .fail("..."))
        }
        let date = Calendar.current.dateComponents([.day, .year, .month], from: actual.date)
        if let year = year, year != date.year {
            return PredicateResult(bool: false, message: .fail("expected year: \(year), but got: \(String(describing: date.year))"))
        }
        if let month = month, month != date.month {
            return PredicateResult(bool: false, message: .fail("expected month: \(month), but got: \(String(describing: date.month))"))
        }
        if let day = day, day != date.day {
            return PredicateResult(bool: false, message: .fail("expected day: \(day), but got: \(String(describing: date.day))"))
        }

        return PredicateResult(bool: true, message: .fail(""))
    }
}
