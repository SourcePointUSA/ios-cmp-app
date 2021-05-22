//
//  PMMessage.swift
//  Pods
//
//  Created by Vilas on 01/04/21.
//

import Foundation

@objc public class PMLongButtonAttributes: NSObject, Codable {
    public let onText: String?
    public let offText: String?
    public let customCategoryText: String?
    public let customVendorText: String?

    public init(onText: String?, offText: String, customCategoryText: String?, customVendorText: String) {
        self.onText = onText
        self.offText = offText
        self.customCategoryText = customCategoryText
        self.customVendorText = customVendorText
    }
}

@objc public class PMSliderAttributes: NSObject, Codable {
    public let consentText: String?
    public let legitInterestText: String?

    public init(consentText: String?, legitInterestText: String) {
        self.consentText = consentText
        self.legitInterestText = legitInterestText
    }
}

@objc public class PMFontAttributes: NSObject, Codable {
    public let fontSize: CGFloat
    public let fontWeight: String
    public let color: String?
    public let fontFamily: String

    public init(fontSize: CGFloat, fontWeight: String, color: String?, fontFamily: String) {
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.color = color
        self.fontFamily = fontFamily
    }
}

@objc public class PMStyleAttributes: NSObject, Codable {
    public let backgroundColor: String?
    public let width: Int?
    public let font: PMFontAttributes?
    public let onFocusBackgroundColor: String?
    public let onUnfocusBackgroundColor: String?
    public let onFocusTextColor: String?
    public let onUnfocusTextColor: String?
    public let activeBackgroundColor: String?
    public let activeFont: PMFontAttributes?

    public init(
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

@objc public class PMUIComponents: NSObject, Codable {
    public let id: String
    public let type: String
    public let text: String?
    public let style: PMStyleAttributes?
    public let src: String?
    public let textDetails: PMLongButtonAttributes?
    public let sliderDetails: PMSliderAttributes?

    public init(id: String, type: String, text: String?, style: PMStyleAttributes?, src: String?, textDetails: PMLongButtonAttributes?, sliderDetails: PMSliderAttributes?) {
        self.id = id
        self.type = type
        self.text = text
        self.style = style
        self.src = src
        self.textDetails = textDetails
        self.sliderDetails = sliderDetails
    }
}

@objc public class SPPrivacyManager: NSObject, Codable {
    public let showPrivacyPolicyBtn: Bool?
    public let style: PMStyleAttributes
    public let components: [PMUIComponents]

    public init(showPrivacyPolicyBtn: Bool?, style: PMStyleAttributes, components: [PMUIComponents]) {
        self.showPrivacyPolicyBtn = showPrivacyPolicyBtn
        self.style = style
        self.components = components
    }
}
