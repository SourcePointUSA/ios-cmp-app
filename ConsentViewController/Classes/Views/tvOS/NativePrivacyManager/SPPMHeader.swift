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
            text = spText.text
            textColor = UIColor(hexString: spText.style?.font?.color)
            font = UIFont(from: spText.style?.font)
        }
    }
}

extension UIButton {
    func setup(from spButton: SPNativeButton?) {
        if let spButton = spButton {
            isHidden = false
            setTitle(spButton.text, for: .normal)
            setTitleColor(UIColor(hexString: spButton.style?.onUnfocusTextColor), for: .normal)
            setTitleColor(UIColor(hexString: spButton.style?.onFocusTextColor), for: .focused)
            backgroundColor = UIColor(hexString: spButton.style?.onUnfocusBackgroundColor)
            titleLabel?.font = UIFont(from: spButton.style?.font)
        }
    }
}

@IBDesignable
class SPPMHeader: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBAction func onBackButtonPressed(_ sender: Any) {
        if let callback = onBackButtonTapped {
            callback()
        }
    }

    var spBackButton: SPNativeButton? {
        didSet {
            backButton.setup(from: spBackButton)
        }
    }
    var spTitleText: SPNativeText? {
        didSet {
            titleLabel.setup(from: spTitleText)
        }
    }
    var onBackButtonTapped: (() -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSubViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }

    func loadSubViews() {
        let nib = UINib(nibName: "SPPMHeader", bundle: Bundle.framework)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
