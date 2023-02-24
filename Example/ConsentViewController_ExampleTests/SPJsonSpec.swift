//
//  SPJsonSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 13.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable force_try

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPJsonSpec: QuickSpec {
    let jsonSample = """
    {
        "arr": [1, "2", null],
        "bool": true,
        "double": 1.01,
        "fake int": "1",
        "int": 1,
        "null": null,
        "obj": {
            "foo": "bar"
        },
        "string": "hello there"
    }
    """
    var json: Any {
        try! JSONSerialization.jsonObject(with: jsonSample.data(using: .utf8)!) // swiftlint:disable:this force_unwrapping
    }

    override func spec() {
        describe("SPJson") {
            it("parses all primitive types of data") {
                let spJson = try! SPJson(self.json)
                expect(spJson["string"]?.stringValue) == "hello there"
                expect(spJson["fake int"]?.stringValue) == "1"
                expect(spJson["double"]?.doubleValue) == 1.01
                expect(spJson["bool"]?.boolValue) == true
                expect(spJson["obj"]?.objectValue?["foo"]?.stringValue) == "bar"
                expect(spJson["arr"]?.arrayValue?[0].intValue) == 1
                expect(spJson["arr"]?.arrayValue?[1].stringValue) == "2"
                expect(spJson["arr"]?.arrayValue?[2].nullValue).to(beNil())
                expect(spJson["null"]?.nullValue).to(beNil())
            }

            it("can be encoded to and decoded to JSON") {
                let spJson = try! SPJson(self.json)
                let encoded = try! JSONEncoder().encodeResult(spJson).get()
                let decoded = try! JSONDecoder().decode(SPJson.self, from: encoded).get()
                expect(decoded["string"]?.stringValue) == "hello there"
                expect(decoded["fake int"]?.stringValue) == "1"
                expect(decoded["double"]?.doubleValue) == 1.01
                expect(decoded["bool"]?.boolValue) == true
                expect(decoded["obj"]?.objectValue?["foo"]?.stringValue) == "bar"
                expect(decoded["arr"]?.arrayValue?[0].intValue) == 1
                expect(decoded["arr"]?.arrayValue?[1].stringValue) == "2"
                expect(decoded["arr"]?.arrayValue?[2].nullValue).to(beNil())
                expect(decoded["null"]?.nullValue).to(beNil())
            }

            it("empty constructor instantiates an equivalent to empty object") {
                expect(SPJson().dictionaryValue).to(beAKindOf([String: Any].self))
                expect(SPJson().dictionaryValue).to(beEmpty())
            }
        }
    }
}
