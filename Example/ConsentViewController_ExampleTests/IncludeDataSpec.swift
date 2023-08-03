//
//  IncludeDataSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 03.08.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

public func stringify<T: Encodable>(_ obj: T) -> String {
    guard let data = try? JSONEncoder().encode(obj),
          let metadataString = String(data: data, encoding: .utf8) else {
        return ""
    }

    return metadataString
}

class IncludeDataSpec: QuickSpec {
    override func spec() {
        it("can be stringified") {
            let stringified = stringify(IncludeData(gppConfig: nil))
            expect(stringified).to(contain(#""localState":{"type":"RecordString"}"#))
            expect(stringified).to(contain(#""TCData":{"type":"RecordString"}"#))
            expect(stringified).to(contain(#""webConsentPayload":{"type":"string"}"#))
            expect(stringified).to(contain(#""categories":true"#))
            expect(stringified).to(contain(#""translateMessage":true"#))
        }

        describe("when gpp config is nil") {
            it("doesn't include gpp data") {
                expect(stringify(IncludeData(gppConfig: nil))).notTo(contain(
                    #""GPPData""#
                ))
            }
        }

        describe("when gpp config is present") {
            it("includes GPPData") {
                expect(stringify(IncludeData(gppConfig: SPGPPConfig()))).to(contain(
                    #""GPPData""#
                ))
            }
        }
    }
}
