//
//  PropertyListViewControllerTest.swift
//  SourcePointMetaAppTests
//
//  Created by Vilas on 4/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndTypeText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        self.tap()
        if self.buttons["Clear text"].exists {
            // use the clear button
            self.buttons["Clear text"].tap()
        } else {
            // delete using the keyboard
            let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
            self.typeText(deleteString)
        }
        self.typeText(text)
    }
    
    func scrollTo(element: XCUIElement) {
        // Account tabBar for offscreen element
        let tabBar = XCUIApplication().tabBars.element(boundBy: 0)
        while element.frame.intersects(tabBar.frame) {
            swipeUp()
        }
    }
   
    /**
     Allows tap on element even if it is not hittable
    */
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
