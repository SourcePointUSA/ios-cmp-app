//
//  ExpandableHeaderView.swift
//  TableViewPOC
//
//  Created by Vilas on 12/05/21.
//

import UIKit

protocol  ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }

    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.textColor = UIColor.black
        contentView.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.7960784314, blue: 0.5882352941, alpha: 1)
    }
}
