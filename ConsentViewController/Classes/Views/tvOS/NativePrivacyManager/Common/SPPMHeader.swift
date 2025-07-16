//
//  SPPMHeader.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 28.05.21.
//

import Foundation
import TVUIKit

extension UILabel {
    func setup(from spText: SPNativeText?) {
        if let spText = spText {
            isHidden = false
            attributedText = spText.settings.text.htmlToAttributedString
            textColor = UIColor(hexString: spText.settings.style.font.color)
            font = UIFont(from: spText.settings.style.font)
        }
    }
}

@IBDesignable
class SPPMHeader: UIView {
    var spBackButton: SPAppleTVButton?

    var spTitleText: SPNativeText? {
        didSet {
            titleLabel.setup(from: spTitleText)
            titleLabel.text = titleLabel.text?.trimmingCharacters(in: .newlines)
            titleLabel.textAlignment = .center
        }
    }

    var onBackButtonTapped: (() -> Void)?

    override var isAccessibilityElement: Bool {
        get { false }
        set {}
    }

    override var accessibilityElements: [Any]? {
        get { [titleLabel as Any, backButton as Any] }
        set {}
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var backButton: SPAppleTVButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSubViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }

    @IBAction func onBackButtonPressed(_ sender: Any) {
        if let callback = onBackButtonTapped {
            callback()
        }
    }

    func loadSubViews() {
        let nib = UINib(nibName: "SPPMHeader", bundle: Bundle.framework)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        titleLabel.accessibilityIdentifier = "Header Title"
        titleLabel.isAccessibilityElement = true
        titleLabel.textAlignment = .center
        backButton.accessibilityIdentifier = "Back Button"
        backButton.isAccessibilityElement = true
        addSubview(contentView)
    }
}
