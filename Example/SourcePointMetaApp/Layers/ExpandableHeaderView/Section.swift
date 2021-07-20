//
//  Section.swift
//  TableViewPOC
//
//  Created by Vilas on 12/05/21.
//

import Foundation

struct Section {
    var campaignTitle: String!
    var expanded: Bool!

    init(campaignTitle: String, expanded: Bool) {
        self.campaignTitle = campaignTitle
        self.expanded = expanded
    }
}
