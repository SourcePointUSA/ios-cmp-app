//
//  QueryParamEncodableSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 31.08.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class QueryParamEncodableSpec: QuickSpec {
    struct MockMetaData: QueryParamEncodable {
        let foo = "bar"
    }

    override func spec() {
        it("should encode to a stringified json object") {
            let mockData = MockMetaData()
            expect(mockData.stringified).to(equal("{\"foo\":\"bar\"}"))
        }
    }
}
