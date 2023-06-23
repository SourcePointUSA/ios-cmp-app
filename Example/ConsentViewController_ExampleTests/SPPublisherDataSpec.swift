//
//  SPPublisherDataSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 16.06.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPPublisherDataSpec: QuickSpec {
    struct MyEncodable: Encodable {
        let custom = "value"
    }

    override func spec() {
        it("supports any encodable data") {
            let pubData: SPPublisherData = [
                "string": .init("stringValue"),
                "number": .init(123),
                "bool": .init(false),
                "null": .init(nil),
                "array": .init([1, 2, 3]),
                "dict": .init(["foo": "bar"]),
                "object": .init(MyEncodable())
            ]
            guard let encodedPubData = try? JSONEncoder().encode(pubData),
                  let decodedPubData = String(data: encodedPubData, encoding: .utf8) else {
                fail("Couldn't encode/decode pubData")
                return
            }

//            {
//                "number":123,
//                "object":{"custom":"value"},
//                "string":"stringValue",
//                "null":null,
//                "bool":false,
//                "array":[1,2,3],
//                "dict":{"foo":"bar"}
//            }

            expect(decodedPubData).to(beginWith("{"))
            expect(decodedPubData).to(contain(#""number":123"#))
            expect(decodedPubData).to(contain(#""object":{"custom":"value"}"#))
            expect(decodedPubData).to(contain(#""string":"stringValue""#))
            expect(decodedPubData).to(contain(#""null":null"#))
            expect(decodedPubData).to(contain(#""bool":false"#))
            expect(decodedPubData).to(contain(#""array":[1,2,3]"#))
            expect(decodedPubData).to(contain(#""dict":{"foo":"bar"}"#))
            expect(decodedPubData).to(endWith("}"))
        }
    }
}
