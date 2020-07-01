//
//  CustomMatchers.swift
//  SPGDPRExampleAppUITests
//
//  Created by Andre Herculano on 22.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Nimble

/// A Nimble matcher that succeeds when an XCUIElement shows up after
/// a certain amount of time. 10 seconds by default
public func showUp() -> Predicate<XCUIElement> {
    return Predicate.simple("show up") { actualExpression in
        guard let actual = try actualExpression.evaluate() else { return .fail }
        return PredicateStatus(bool: actual.waitForExistence(timeout: 10))
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
        return PredicateStatus(bool: !actual.exists)
    }
}
