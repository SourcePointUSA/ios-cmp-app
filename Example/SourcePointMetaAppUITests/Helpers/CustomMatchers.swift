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

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time. 10 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    return Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: Nimble.AsyncDefaults.Timeout))
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
        QuickSpec.current.waitForExpectations(timeout: Nimble.AsyncDefaults.Timeout)
        return PredicateStatus(bool: !actual.exists)
    }
}


