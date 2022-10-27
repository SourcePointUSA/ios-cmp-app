//
//  CustomMatchers.swift
//  SourcePointMetaAppUITests
//
//  Created by Vilas on 28/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import Quick

/// A matcher that checks if a `XCUIElement` contains the given text
public func containText(_ text: String) -> Predicate<XCUIElement> {
    return Predicate.simple("contain text") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.label.contains(text))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time. 10 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    return Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        if let timeout = TimeInterval(dispatchTimeInterval: Nimble.AsyncDefaults.timeout) {
            return PredicateStatus(bool: actual.waitForExistence(timeout: timeout))
        }
        return PredicateStatus(bool: actual.waitForExistence(timeout: 20))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time.
public func showUp(in timeout: TimeInterval) -> Predicate<XCUIElement> {
    return Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: timeout))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement no longer exists. Due to its async nature, it should
/// be used together with `.toEventually`.
public func disappear() -> Predicate<XCUIElement> {
    return Predicate.simple("disappear") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        QuickSpec.current.expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: actual, handler: nil)
        if let timeout = TimeInterval(dispatchTimeInterval: Nimble.AsyncDefaults.timeout) {
            QuickSpec.current.waitForExpectations(timeout: timeout)
            return PredicateStatus(bool: !actual.exists)
        }
        return PredicateStatus(bool: actual.waitForExistence(timeout: 20))
    }
}

extension TimeInterval {
    init?(dispatchTimeInterval: DispatchTimeInterval) {
        switch dispatchTimeInterval {
        case .seconds(let value):
            self = Double(value)
        case .milliseconds(let value):
            self = Double(value)
        case .microseconds(let value):
            self = Double(value)
        case .nanoseconds(let value):
            self = Double(value)
        case .never:
            return nil
        @unknown default:
            return nil
        }
    }
}



