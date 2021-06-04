//
//  PMMessage.swift
//  Pods
//
//  Created by Vilas on 01/04/21.
//

import Foundation
import UIKit

@objc class PMLongButtonAttributes: NSObject, Codable {
    let onText: String?
    let offText: String?
    let customCategoryText: String?
    let customVendorText: String?

    init(onText: String?, offText: String, customCategoryText: String?, customVendorText: String) {
        self.onText = onText
        self.offText = offText
        self.customCategoryText = customCategoryText
        self.customVendorText = customVendorText
    }
}

@objc class PMSliderAttributes: NSObject, Codable {
    let consentText: String?
    let legitInterestText: String?

    init(consentText: String?, legitInterestText: String) {
        self.consentText = consentText
        self.legitInterestText = legitInterestText
    }
}

@objc class PMFontAttributes: NSObject, Codable {
    let fontSize: CGFloat
    let fontWeight: String
    let color: String?
    let fontFamily: String

    init(fontSize: CGFloat, fontWeight: String, color: String?, fontFamily: String) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.color = color
        self.fontFamily = fontFamily
    }
}

@objc class PMStyleAttributes: NSObject, Codable {
    let backgroundColor: String?
    let width: Int?
    let font: PMFontAttributes?
    let onFocusBackgroundColor: String?
    let onUnfocusBackgroundColor: String?
    let onFocusTextColor: String?
    let onUnfocusTextColor: String?
    let activeBackgroundColor: String?
    let activeFont: PMFontAttributes?

    init(
        backgroundColor: String?,
        width: Int?,
        font: PMFontAttributes?,
        onFocusBackgroundColor: String?,
        onUnfocusBackgroundColor: String?,
        onFocusTextColor: String?,
        onUnfocusTextColor: String?,
        activeBackgroundColor: String,
        activeFont: PMFontAttributes?
    ) {
        self.backgroundColor = backgroundColor
        self.width = width
        self.font = font
        self.onFocusBackgroundColor = onFocusBackgroundColor
        self.onUnfocusBackgroundColor = onUnfocusBackgroundColor
        self.onFocusTextColor = onFocusTextColor
        self.onUnfocusTextColor = onUnfocusTextColor
        self.activeBackgroundColor = activeBackgroundColor
        self.activeFont = activeFont
    }
}

@objc class PMUIComponents: NSObject, Codable {
    let id: String
    let type: String
    let text: String?
    let style: PMStyleAttributes?
    let src: String?
    let textDetails: PMLongButtonAttributes?
    let sliderDetails: PMSliderAttributes?

    init(id: String, type: String, text: String?, style: PMStyleAttributes?, src: String?, textDetails: PMLongButtonAttributes?, sliderDetails: PMSliderAttributes?) {
        self.id = id
        self.type = type
        self.text = text
        self.style = style
        self.src = src
        self.textDetails = textDetails
        self.sliderDetails = sliderDetails
    }
}

@objc class SPPrivacyManager: NSObject, Codable {
    let showPrivacyPolicyBtn: Bool?
    let style: PMStyleAttributes
    let components: [PMUIComponents]

    init(showPrivacyPolicyBtn: Bool?, style: PMStyleAttributes, components: [PMUIComponents]) {
        self.showPrivacyPolicyBtn = showPrivacyPolicyBtn
        self.style = style
        self.components = components
    }
}
