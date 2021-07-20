//
//  SideMenuViewController.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 24/06/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: BaseViewController {

    @IBOutlet var sideMenuTableView: UITableView!
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0

    var menu: [SideMenuModel] = [
        SideMenuModel(title: "Load GDPR PM"),
        SideMenuModel(title: "Load CCPA PM"),
        SideMenuModel(title: "Network Call Logs")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.3602207303, green: 0.4389211833, blue: 0.5448188186, alpha: 1)
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.backgroundColor = #colorLiteral(red: 0.3602207303, green: 0.4389211833, blue: 0.5448188186, alpha: 1)
        sideMenuTableView.separatorStyle = .none

        // Set Highlighted Cell
        DispatchQueue.main.async { [weak self] in
            let defaultRow = IndexPath(row: self?.defaultHighlightedCell ?? 0, section: 0)
            self?.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        sideMenuTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.titleLabel.text = menu[indexPath.row].title

        // Highlighted color
        let customSelectionColorView = UIView()
        customSelectionColorView.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.7960784314, blue: 0.5882352941, alpha: 1)
        cell.selectedBackgroundView = customSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedCell(indexPath.row)
    }
}
