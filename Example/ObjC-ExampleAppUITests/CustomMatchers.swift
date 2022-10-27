//
//  CustomMatchers.swift
//  ObjC-ExampleAppUITests
//
//  Created by Vilas on 08/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
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
/// a certain amount of time. 20 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    return Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: 25))
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
        QuickSpec.current.waitForExpectations(timeout: 20)
        return PredicateStatus(bool: !actual.exists)
    }
}
