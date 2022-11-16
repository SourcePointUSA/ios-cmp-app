//
//  JSONView.swift
//  JSONView
//
//  Created by Quentin Fasquel on 16/04/2020.
//

import SwiftUI

public typealias JSON = [String: AnyHashable]

// MARK: -

public struct JSONView: View {
    private let rootArray: [JSON]?
    private let rootDictionary: JSON

    public init(_ array: [JSON]) {
        self.rootArray = array
        self.rootDictionary = JSON()
    }

    public init(_ dictionary: JSON) {
        self.rootArray = nil
        self.rootDictionary = dictionary
    }

    public init(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            self.rootArray = jsonData as? [JSON]
            self.rootDictionary = jsonData as? JSON ?? JSON()
        } catch {
            self.rootArray = nil
            self.rootDictionary = JSON()
            print("JSONView error: \(error.localizedDescription)")
        }
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            JSONTreeView(rootArray ?? rootDictionary)
                .padding(.top, 10)
                .padding(.bottom, 60)
                .padding(.trailing, 10)
        }
    }
}
