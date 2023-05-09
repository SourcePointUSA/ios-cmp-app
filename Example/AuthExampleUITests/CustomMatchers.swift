//
//  CustomMatchers.swift
//  AuthExampleUITests
//
//  Created by Andre Herculano on 27.04.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Nimble
import Quick
import XCTest

extension DispatchTimeInterval {
    func toDouble() -> Double {
        var result: Double = 0
        switch self {
            case .seconds(let value):
                result = Double(value)

            case .milliseconds(let value):
                result = Double(value) * 0.001

            case .microseconds(let value):
                result = Double(value) * 0.000_001

            case .nanoseconds(let value):
                result = Double(value) * 0.000_000_001

            case .never:
                result = Double.infinity
            @unknown default:
                result = Double.infinity
        }
        return result
    }
}

/// A matcher that checks if a `XCUIElement` contains the given text
public func containText(_ text: String) -> Predicate<XCUIElement> {
    Predicate.simple("contain text") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.label.contains(text))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time. 20 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: Nimble.AsyncDefaults.timeout.toDouble()))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time.
public func showUp(in timeout: TimeInterval) -> Predicate<XCUIElement> {
    Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: timeout))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement no longer exists. Due to its async nature, it should
/// be used together with `.toEventually`.
public func disappear() -> Predicate<XCUIElement> {
    Predicate.simple("disappear") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        QuickSpec.current.expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: actual, handler: nil)
        QuickSpec.current.waitForExpectations(timeout: Double(Nimble.AsyncDefaults.timeout.toDouble()))
        return PredicateStatus(bool: !actual.exists)
    }
}
