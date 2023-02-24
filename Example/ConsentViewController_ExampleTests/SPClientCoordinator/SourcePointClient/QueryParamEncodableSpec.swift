//
//  QueryParamEncodableSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 31.08.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class QueryParamEncodableSpec: QuickSpec {
    struct MockMetaData: QueryParamEncodable {
        let foo = "bar"
    }

    override func spec() {
        it("should encode to a stringified json object") {
            let mockData = MockMetaData()
            expect(mockData.stringified) == "{\"foo\":\"bar\"}"
        }
    }
}
