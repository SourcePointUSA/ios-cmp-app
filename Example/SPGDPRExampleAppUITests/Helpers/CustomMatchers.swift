//
//  CustomMatchers.swift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 22.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Nimble
import Quick
import XCTest

public typealias Predicate = Nimble.Predicate

extension TimeInterval {
    init(dispatchTimeInterval: DispatchTimeInterval) {
        switch dispatchTimeInterval {
        case .seconds(let value):
            self = Double(value)

        case .milliseconds(let value):
            self = Double(value) / 1_000

        case .microseconds(let value):
            self = Double(value) / 1_000_000

        case .nanoseconds(let value):
            self = Double(value) / 1_000_000_000

        case .never:
            self = 1_000_000_000
        @unknown default:
            self = 1_000_000_000
        }
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
/// a certain amount of time. 10 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: TimeInterval(dispatchTimeInterval: Nimble.AsyncDefaults.timeout)
        ))
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
        QuickSpec.current.expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: actual)
        QuickSpec.current.waitForExpectations(timeout: TimeInterval(dispatchTimeInterval: Nimble.AsyncDefaults.timeout)
        )
        return PredicateStatus(bool: !actual.exists)
    }
}

/// A Nimble matcher that succeeds when an XCUIElement is enable
public func beEnabled() -> Predicate<XCUIElement> {
    Predicate.simple("beEnabled") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.isEnabled)
    }
}

/// A Nimble matcher that succeeds when an XCUIElement is disabled
public func beDisabled() -> Predicate<XCUIElement> {
    Predicate.simple("beDisabled") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: !actual.isEnabled)
    }
}

/// A Nimble matcher that succeeds when an XCUIElement is disabled
public func beToggledOn() -> Predicate<XCUIElement> {
    Predicate.simple("beToggledOn") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.value as? String == "1")
    }
}

/// A Nimble matcher that succeeds when an XCUIElement is disabled
public func beToggledOff() -> Predicate<XCUIElement> {
    Predicate.simple("beToggledOff") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.value as? String != "1")
    }
}
