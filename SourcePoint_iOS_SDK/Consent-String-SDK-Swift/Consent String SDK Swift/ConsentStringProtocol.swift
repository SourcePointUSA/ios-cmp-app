//
//  ConsentStringProtocol.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

protocol ConsentStringProtocol {
    
    init(consentString: String) throws
    var consentString:String {get set}
    var cmpId:Int {get}
    var consentScreen:Int {get}
    var consentLanguage:String {get}
    var purposesAllowed:[Int8] {get}
    func purposeAllowed(forPurposeId purposeId:Int8) -> Bool
    func isVendorAllowed(vendorId:Int) -> Bool
    
}
