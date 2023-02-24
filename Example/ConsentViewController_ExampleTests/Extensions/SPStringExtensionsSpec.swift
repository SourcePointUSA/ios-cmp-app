//
//  SPString.swift
//  ConsentViewController_ExampleTests
//
//  Created by Dmytro Fedko on 17.12.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPStringExtensionsSpec: QuickSpec {
    override func spec() {
        describe("stripOutHtml") {
            it("should strip any HTML and CSS markup tags from string") {
                let cssHtml = """
                <head>
                <title>HTML - head tag</title>
                <strong><i><b>strongbolditalic</b></i></strong>
                <meta name="author" content="john smith">
                <style>body {color: black}</style>
                <link rel="stylesheet" href="stylesheet.css">
                <base href="https://www.tutorialstonight.com">
                <script src="script.js"></script>
                <noscript>Your browser does not support javascript.</noscript>
                </head>
                """
                let stripped = cssHtml.stripOutHtml()
                expect(stripped) == "\nHTML - head tag\nstrongbolditalic\n\n\n\n\n\nYour browser does not support javascript.\n"
            }
        }
    }
}
