//
//  CustomMatchers.swift
//  TVOSExampleAppUITests
//
//  Created by Vilas on 27/09/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Nimble
import Quick
import XCTest

public typealias Predicate = Nimble.Matcher

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
        guard let actual = try? actualExpression.evaluate() else { return .fail }
        return MatcherStatus(bool: actual.label.contains(text))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time. 10 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return MatcherStatus(bool: actual.waitForExistence(timeout: Nimble.PollingDefaults.timeout.timeInterval))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time.
public func showUp(in timeout: TimeInterval) -> Predicate<XCUIElement> {
    Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return MatcherStatus(bool: actual.waitForExistence(timeout: timeout))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement no longer exists. Due to its async nature, it should
/// be used together with `.toEventually`.
public func disappear() -> Predicate<XCUIElement> {
    Predicate.simple("disappear") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        QuickSpec.current.expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: actual, handler: nil)
        QuickSpec.current.waitForExpectations(timeout: Nimble.PollingDefaults.timeout.timeInterval)
        return MatcherStatus(bool: !actual.exists)
    }
}
