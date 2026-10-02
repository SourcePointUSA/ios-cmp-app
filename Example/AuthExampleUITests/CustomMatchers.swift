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

/// A matcher that checks if a `XCUIElement` contains the given text
public func containText(_ text: String) -> Matcher<XCUIElement> {
    Matcher.simple("contain text") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return MatcherStatus(bool: actual.label.contains(text))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time. 20 seconds by default
public func showUp() -> Matcher<XCUIElement> {
    Matcher.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return MatcherStatus(bool: actual.waitForExistence(timeout: Nimble.PollingDefaults.timeout.timeInterval))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time.
public func showUp(in timeout: TimeInterval) -> Matcher<XCUIElement> {
    Matcher.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return MatcherStatus(bool: actual.waitForExistence(timeout: timeout))
    }
}

/// A Nimble matcher that succeeds when an XCUIElement no longer exists. Due to its async nature, it should
/// be used together with `.toEventually`.
public func disappear() -> Matcher<XCUIElement> {
    Matcher.simple("disappear") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        QuickSpec.current.expectation(for: NSPredicate(format: "exists == FALSE"), evaluatedWith: actual, handler: nil)
        QuickSpec.current.waitForExpectations(timeout: Nimble.PollingDefaults.timeout.timeInterval)
        return MatcherStatus(bool: !actual.exists)
    }
}
